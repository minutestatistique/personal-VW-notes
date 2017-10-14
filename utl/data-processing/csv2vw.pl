#!/usr/bin/perl

use strict;
use warnings;

my $src = shift;	# input csv file
my $dst = shift;	# output vw data
my $type = shift;	# output vw data

my $block = 1000000;  # progress indicator

# parsing file
#------------------------------------------------------------------------------
open(SRC, "<", $src) or die "could not open $src!";
open(DST, ">", $dst) or die "could not open $dst!";

# data
my $count = 1;
my @cont = (1, 2, 3, 4, 30, 31, 32, 33, 34, 39, 40, 47, 48, 54, 55);
while (<SRC>) {
  chomp;
  s/"//g;      # deleting " for the quote option from importation
  my @x = split("\t", $_, -1);
	if ($type ne 'train') {
		unshift @x, '';
	}
	my $label = '';
	if ($x[29] eq '1' || $x[29] eq '2') { # QuadClass: 1 & 2 = cooperation, 3 & 4 = conflict
		$label = '-1';
	} else {
		$label = '1';
	}
  my $row = $label." | ";
  for (my $col = 0; $col <= 57; $col++) {
		if ($x[$col] ne "" && $col != 0 && $col != 29) { # Exclude GlobalEventID, QuadClass from features
			if ($col ~~ @cont) {									# Continuous features
				$row = $row."C_$col:".$x[$col]." ";
			} else {															# Discrete features
				$row = $row."D_$col=".$x[$col]." ";
			}
		}
  }
  print DST "$row\n";

  $count++;
  if (($count % $block) == 0) {
    print $count."\n";
  }
}

close(SRC);
close(DST);
