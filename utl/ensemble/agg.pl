#!/usr/bin/perl

use strict;
use warnings;
use List::Util qw(sum);

sub avg { sum(@_)/@_ }

# ARGS
#------------------------------------------------------------------------------
my $input = shift;		# input predictions
my $output = shift;		# aggregated prediction

my $block = 1000000;	# progress indicator

# FILES PROCESSING
#------------------------------------------------------------------------------
open(SRC, "<", $input) or die "Could not open file '$input' $!";
open(DST, ">", $output) or die "Could not open file '$output' $!";

my $count = 1;
while (<SRC>) {
	chomp;
	$_ =~ s/"//g;
	my @x = split(",", $_);

	print DST avg(@x)."\n";

	$count++;
	if (($count % $block) == 0) {			# print out progress every $block lines
		print $count."\n";
	}
}

close(SRC);
close(DST);

