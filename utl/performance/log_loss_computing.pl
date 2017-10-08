#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw[min max];

# ARGS
#------------------------------------------------------------------------------
my $obs = shift;		# observed outcomes (test.vw data file)
my $pred = shift;		# predicted probabilities
my $out = shift;		# output

my $block = 1000000;	# progress indicator

# FILES PROCESSING
#------------------------------------------------------------------------------
open(OBS, "<", $obs) or die "Could not open file '$obs' $!";
open(PRED, "<", $pred) or die "Could not open file '$pred' $!";
open(OUT, ">", $out) or die "Could not open file '$out' $!";

my $rowcount = 1;
my $count = 1;
my $sum = 0;
do {
	if (defined(my $obsrow = <OBS>) && defined(my $predrow = <PRED>)) {
		chomp $obsrow;
		chomp $predrow;
		my @elmts = split(/\ \|/, $obsrow);
		my $observed = ($elmts[0] == "-1") ? 0 : 1;	# observed outcome
		my $predicted = 1/(1+exp(-$predrow));		# logistic transformation
		my $eps = 1e-15;							# to avoid taking log of 0
		$predicted = max($eps, $predicted);
		$predicted = min(1-$eps, $predicted);
		$sum += $observed*log($predicted) + (1-$observed)*log(1-$predicted);
		$count++;
	}
	$rowcount++;
	if (($rowcount % $block) == 0) {
		print "$rowcount\n";
	}
} until eof OBS and eof PRED;

print OUT -1*$sum/$count."\n";

close(OBS);
close(PRED);
close(OUT);
