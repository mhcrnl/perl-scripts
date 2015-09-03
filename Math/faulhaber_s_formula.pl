#!/usr/bin/perl

# Author: Daniel "Trizen" Șuteu
# License: GPLv3
# Date: 03 September 2015
# Website: https://github.com/trizen

# The formula for calculating the sum of series such as:
#    1^p + 2^p + 3^p + ... n^p
# where p is a positive integer.

# See also: https://en.wikipedia.org/wiki/Faulhaber%27s_formula

use 5.010;
use strict;
use warnings;

use bigrat (try => 'GMP');

# This function returns the nth Bernoulli number
# See: https://en.wikipedia.org/wiki/Bernoulli_number
sub bernoulli_number {
    my ($n) = @_;

    my @A;
    for my $m (0 .. $n) {
        $A[$m] = 1 / ($m + 1);

        for (my $j = $m ; $j > 0 ; $j--) {
            $A[$j - 1] = $j * ($A[$j - 1] - $A[$j]);
        }
    }

    $n % 2 ? -$A[0] : $A[0];    # B1 = -1/2
}

# The binomial coefficient
# See: https://en.wikipedia.org/wiki/Binomial_coefficient
sub nok {
    my ($n, $k) = @_;
    Math::BigRat->new($n)->bnok($k);
}

# The Faulhaber's formula
# See: https://en.wikipedia.org/wiki/Faulhaber%27s_formula
sub faulhaber_s_formula {
    my ($p, $n) = @_;

    my $sum = 0;
    for my $j (0 .. $p) {
        $sum += nok($p + 1, $j) * bernoulli_number($j) * $n**($p + 1 - $j);
    }

    $sum / ($p + 1);
}

# Alternate expression using Bernoulli polynomials
# See: https://en.wikipedia.org/wiki/Faulhaber%27s_formula#Alternate_expressions

sub bernoulli_polynomials {
    my ($n, $x) = @_;

    my $sum = 0;
    for my $k (0 .. $n) {
        $sum += nok($n, $k) * bernoulli_number($n - $k) * $x**$k;
    }

    $sum;
}

sub faulhaber_s_formula_2 {
    my ($p, $n) = @_;
    (bernoulli_polynomials($p + 1, $n + 1) - bernoulli_polynomials($p + 1, 1)) / ($p + 1);
}

# Test for 0^3 + 1^3 + 2^3 + ... + 10^3
foreach my $i (0 .. 10) {
    say "$i: ", faulhaber_s_formula(3, $i + 1);
}
