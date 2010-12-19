use strict;
use warnings;

use Test::More;
BEGIN { use_ok('Acme::SZaru') };

my $sut;
my $estimate;

{
    $sut = Acme::SZaru::QuantileEstimator->new(10);
    $estimate = $sut->estimate();
    is(ref($estimate), "ARRAY", "return [0] if no addtion exists");
    is(scalar @{$estimate}, 1, "return [0] if no addtion exists");
    is_deeply($estimate, [0], "return [0] if no addtion exists");
    $estimate = undef;
}

{
    $sut = Acme::SZaru::QuantileEstimator->new(10);
    $sut->add_elem(10);
    $sut->add_elem(7);
    $estimate = $sut->estimate();
    is(ref($estimate), "ARRAY", "return [min, max] if quantile_elems is 0");
    is(scalar @{$estimate}, 2, "return [min, max] if quantile_elems is 0");
    is_deeply($estimate, [7,10], "return [min, max] if quantile_elems is 0");
    $estimate = undef;
}

{
    $sut = Acme::SZaru::QuantileEstimator->new(10);
    $sut->add_elem($_) foreach ((0..4));
    $estimate = $sut->estimate();
    my @expected  = (0,0,1,1,2,2,3,3,4,4);
    is(ref($estimate), "ARRAY", "return exact quantile when the number of elements is small than quantile_elems");
    is(scalar @{$estimate}, 8, "return exact quantile when the number of elements is small than quantile_elems");
    is_deeply($estimate, [0,0,1,1,2,2,3,3,4,4], "return exact quantile when the number of elements is small than quantile_elems");
    $estimate = undef;
}

{
    $sut = Acme::SZaru::QuantileEstimator->new(11);
    foreach my $i (List::Util::shuffle (0..999)) {
        $sut->add_elem($i);
    }
    $estimate = $sut->estimate();
    is(ref($estimate), "ARRAY", "return approximate number when the number of elements is greater than quantile_elems");
    is(scalar @{$estimate}, 11, "return approximate number when the number of elements is greater than quantile_elems");
    for (my $index = 0; $index < scalar @{$estimate}; ++$index) {
        my $exact = $index * 100;
        my $diff = abs($estimate->[$index] - $index);
        cmp_ok($diff, '<', 10);
    }
}
