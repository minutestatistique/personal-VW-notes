#!/bin/bash

# ARGUMENTS
#------------------------------------------------------------------------------
script=$1
n=$2

# DATA PROCESSING
#------------------------------------------------------------------------------
for ((i=0; i < $n; i++))
do
	bash out/src/${script}_${i}.sh &
done

exit 0
