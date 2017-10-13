#!/bin/bash

# ARGUMENTS
#------------------------------------------------------------------------------
input=$1
n=$2

# DATA PROCESSING
#------------------------------------------------------------------------------
nrow=$(wc -l $input | cut -d ' ' -f 1)
step=$(($nrow / $n))

echo "nrow = $nrow"
echo "n = $n"
echo "step = $step"

for ((i=0; i < $n; i++))
do
	begin=$(($i * $step + 1))
	end=$(($i * $step + $step))
	if [ $i -eq $(($n - 1)) ] && [ $nrow -gt $end ]; then
		end=$nrow
	fi
	echo "begin = $begin"
	echo "end = $end"
	echo "sed -n '$begin,${end}p' $input > ${input}_$i" > "out/src/xtract_$i.sh"
done

exit 0
