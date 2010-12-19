use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Acme::SZaru') };

my $sut;
my $estimate;

{
    $sut = Acme::SZaru::UniqueEstimator->new(10);
    $estimate = $sut->estimate();
    is($estimate, 0, "return 0 if no addtion exists");
    $estimate = undef;
}

{
    $sut = Acme::SZaru::UniqueEstimator->new(0);
    $sut->add_elem("test");
    $estimate = $sut->estimate();
    is($estimate, 0, "return 0 if max_elems is 0");
    $estimate = undef;
}

{
    $sut = Acme::SZaru::UniqueEstimator->new(10);
    $sut->add_elem("test".$_) foreach ((0..4));
    $estimate = $sut->estimate();
    my @expected  = (0,0,1,1,2,2,3,3,4,4);
    is($estimate, 5, "return exact number when the number of elements is smaller than max_elems");
    $estimate = undef;
}

{
    use List::Util;
    $sut = Acme::SZaru::UniqueEstimator->new(10);
    foreach ((0..1)) {
        foreach my $i (List::Util::shuffle (0..997)) {
            $sut->add_elem("test".$i);
        }
    }
    $estimate = $sut->estimate();
    my $diff = $estimate - 997;
    my $error_rate = abs($diff / 997.0);
    cmp_ok($error_rate, '<', 0.1);
}

done_testing();
