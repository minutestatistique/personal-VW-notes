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

# header
#my $headerRow = <SRC>;
#chomp($headerRow);
#$headerRow =~ s/"//g;      # deleting " for the quote option from importation
#my @headerElmt = split(",", $headerRow, -1);

# data
my $count = 1;
while (<SRC>) {
  chomp;
  s/"//g;      # deleting " for the quote option from importation
  my @x = split("\t", $_, -1);
	if ($type ne 'train') {
		unshift @x, '';
	}
	my $label = '';
	if ($x[0] eq '0') {
		$label = '-1';
	} elsif ($x[0] eq '1') {
		$label = '1';
	}
  my $row = $label." | ";
  for (my $col = 1; $col <= 39; $col++) {
		if ($x[$col] ne "") {
			if ($col <= 13) {
				$row = $row."C_$col:".$x[$col]." ";
			} else {
				my $col_D = $col - 13;
				$row = $row."D_$col_D=".$x[$col]." ";
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
