use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Acme::SZaru') };

my $te = Acme::SZaru::TopEstimator->new(10);
my $tops = $te->estimate();
is(scalar @{$tops}, 0, "return 0 element if no addition exists");

$te = Acme::SZaru::TopEstimator->new(0);
$te->add_elem("test");
$tops = $te->estimate();
is(scalar @{$tops}, 0, "return 0 if num_tops is 0");

$te = Acme::SZaru::TopEstimator->new(10);
foreach my $i ((0..4)) {
    my $s = "test".$i;
    $te->add_elem($s);
    $te->add_weighted_elem($s, $i);
}
$tops = $te->estimate();
is(scalar @{$tops}, 5, "return 5 elements");
foreach my $i ((0..4)) {
    my $s = 5 - $i - 1;
    is($tops->[$i]->{value}, "test".$s, "expected name");
    my $w = 5 - $i;
    is($tops->[$i]->{weight}, $w, "expected weight");
}

$te = Acme::SZaru::TopEstimator->new(10);
foreach my $i ((0..4)) {
    my $s = "test".$i;
    $te->add_elem($s);
    $te->add_weighted_elem($s, $i);
}

$tops = $te->estimate();
$tops = $te->estimate();
is(scalar @{$tops}, 5, "(2) return 5 elements");
foreach my $i ((0..4)) {
    my $s = 5 - $i - 1;
    is($tops->[$i]->{value}, "test".$s, "(2) expected name");
    my $w = 5 - $i;
    is($tops->[$i]->{weight}, $w, "(2) expected weight");
}

$te = Acme::SZaru::TopEstimator->new(10);
my @elems;
foreach my $i ((0..29)) {
    foreach ((0..($i**2))) {
        push @elems, $i;
    }
}
foreach my $i ((0..999)) {
    my $n = int(rand(5));
    foreach ((0..$n)) {
        push @elems, $i;
    }
}
use List::Util;
foreach my $j (List::Util::shuffle @elems) {
    my $s = "test". $j;
    $te->add_elem($s);
}

$tops = $te->estimate();
is(scalar @{$tops}, 10, "return approximate number when tha number of elements is greather than top_elems");
foreach my $i ((0..9)) {
    my $x = 30 - $i - 1;
    $tops->[$i]->{value} =~ m/test(\d*)/;
    ok(abs($x - int($1)) < 3, "diff should less than 3");
    my $w = 2 * ($x ** 2);
    diag(abs(($tops->[$i]->{weight} - $w) / $w));
    ok(abs(($tops->[$i]->{weight} - $w) / $w) < 0.1, "weight diff should less than 0.1");
}

done_testing();
