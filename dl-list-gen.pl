#!/usr/bin/perl

use strict;
use warnings;

my $pref = shift;	# url prefix
my $suff = shift;	# url suffix
my $years = shift;	# years
my $months = shift;	# months
my $days = shift;		# days

my @years = split(":", $years, -1);
my @months = split(":", $months, -1);
my @days = split(":", $days, -1);

for my $y ($years[0] .. $years[1]) {
	for my $m ($months[0] .. $months[1]) {
		if ($m <= 9) {
			$m = "0$m";
		}
		for my $d ($days[0] .. $days[1]) {
			if ($d <= 9) {
				$d = "0$d";
			}
			print "$pref$y$m$d$suff\n";
		}
	}
}
