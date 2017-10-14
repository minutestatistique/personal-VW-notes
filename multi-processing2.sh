#!/bin/bash

# ARGUMENTS
#------------------------------------------------------------------------------
n=$1

# DATA PROCESSING
#------------------------------------------------------------------------------
for ((i=0; i < $n; i++))
do
	./utl/data-processing/csv2vw.pl data/gdelt.tsv_$i data/gdelt.vw_$i train &
done

exit 0
