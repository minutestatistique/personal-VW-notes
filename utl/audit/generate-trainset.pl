#!/usr/bin/perl -w
my $N = 1000;
for ($i = 1; $i <= $N; $i++) {
    my $a = rand(1);
    my $b = rand(1);
    my $c = rand(1);
    my $d = rand(1);
    my $e = rand(1);
    my $y = $a + 2*$b + 3*$c + 4*$d + 5*$e;
    printf "%g | a:%g b:%g c:%g d:%g e:%g\n", $y, $a, $b, $c, $d, $e;
}
