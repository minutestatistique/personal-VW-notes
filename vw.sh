#!/in/bash

# ARGUMENTS
#------------------------------------------------------------------------------
train_data=$1
test_data=$2
model=$3
train_pred=$4
test_pred=$5

tune=$6
b=$7
l=$8
loss=$9
l1=${10}
l2=${11}
nn=${12}
#r_model=${13}
top_err=${13}
top_err_n=${14}
top_err_w=${15}

# LEARNING
#------------------------------------------------------------------------------
bcmd='vw'

if [ "$tune" != "false" ]; then
	echo '... tuning b'
	b=$(./vw-hypersearch -t $test_data 18 31 vw --loss_function $loss \
			-b % $train_data | cut -d$'\t' -f1)
	echo '... tuning l'
	l=$(./vw-hypersearch -t $test_data 0.1 100 vw --loss_function $loss \
			-b $b -l % $train_data | cut -d$'\t' -f1)
	echo '... tuning l1'
	l1=$(./vw-hypersearch -L -t $test_data 1e-10 5e-4 vw --loss_function $loss \
			 -b $b -l $l --l1 % $train_data | cut -d$'\t' -f1)
	echo '... tuning l2'
	l2=$(./vw-hypersearch -L -t $test_data 1e-10 5e-4 vw --loss_function $loss \
			 -b $b -l $l --l1 $l1 --l2 % $train_data | cut -d$'\t' -f1)
fi

bcmd+=" -b $b" 
bcmd+=" -l $l" 
bcmd+=" --loss_function $loss" 
if [ "$l1" != "none" ]; then
	bcmd+=" --l1 $l1" 
fi
if [ "$l2" != "none" ]; then
	bcmd+=" --l2 $l2" 
fi
if [ "$nn" != "0" ]; then
	bcmd+=" --nn $nn --inpass" 
fi

echo $'\n'
#bcmd=$bcmd' -c --passes 100'
echo 'base command'
echo $bcmd
echo $'\n'

echo '... training'
#cmd=$bcmd' -d $train_data -f $model --invert_hash $r_model'
cmd=$bcmd' -d $train_data -f $model'
echo $cmd
eval $cmd
echo $'\n'

echo '... top errors'
top_e_cmd='./vw-top-errors $top_err_n $top_err_w '$bcmd' -d $train_data > $top_err'
echo $top_e_cmd
eval $top_e_cmd
echo $'\n'

echo '... testing on train'
cmd='vw -d $train_data -t -i $model -p $train_pred --loss_function $loss'
echo $cmd
eval $cmd
echo $'\n'

echo '... testing on test'
cmd='vw -d $test_data -t -i $model -p $test_pred --loss_function $loss'
echo $cmd
eval $cmd
echo $'\n'

exit 0
