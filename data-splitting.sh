#!/bin/bash

# utility functions
#------------------------------------------------------------------------------
data_splitting_index () {
	# args
	input=$1
	n=$2

	# data processing
	nrow=$(wc -l $input | cut -d ' ' -f 1)
	step=$(($nrow / $n))

	for ((i=0; i < $n; i++))
	do
		begin=$(($i * $step + 1))
		end=$(($i * $step + $step))
		# last bin
		if [ $i -eq $(($n - 1)) ] && [ $nrow -gt $end ]; then
			end=$nrow
		fi
		echo "$begin,$end"
	done

}

# begin
#------------------------------------------------------------------------------
i=0
data_splitting_index $1 $2 |\
	while read line; do echo "sed -n ${line}p $1 > $1_$i"; i=$(($i+1)) ; done |\
		parallel --eta -k

exit 0
