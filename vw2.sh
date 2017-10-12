#!/bin/bash

# ARGS
#------------------------------------------------------------------------------
algos=('lr' 'nn' 'svm' 'a')
losses=('logistic' 'logistic' 'hinge')
iter=`expr ${#algos[@]} - 1`

train_data='./data/train.vw'
test_data='./data/test.vw'

model_dir='./out/model'
pred_dir='./out/predict'
perf_dir='./out/perf'

#tune='false'
tune='true'

# TRAINING
#------------------------------------------------------------------------------
hline='-'
for i in $(seq 1 79); do hline+='-' ; done

cat $train_data | cut -d ' ' -f 1 | sed -e 's/^-1/0/' > data/train.labels
cat $test_data | cut -d ' ' -f 1 | sed -e 's/^-1/0/' > data/test.labels

for ((i=0; i < $iter; i++))
do
	echo $'\n'
	echo ${algos[$i]} 
	echo $hline
	b='18'
	l='0.5'
	l1='none'
	l2='none'
	bcmd='vw'
	#bcmd='vw -c --passes 100'
	if [ "$tune" != "false" ]; then
		echo '... tuning b'
		b=$(./utl/tuning/vw-hypersearch -t $test_data 18 31 vw --loss_function ${losses[$i]} \
										 -b % $train_data | cut -d$'\t' -f1)
		echo '... tuning l'
		l=$(./utl/tuning/vw-hypersearch -t $test_data 0.1 100 vw --loss_function ${losses[$i]} \
										 -b $b -l % $train_data | cut -d$'\t' -f1)
		echo '... tuning l1'
		l1=$(./utl/tuning/vw-hypersearch -L -t $test_data 1e-10 5e-4 vw --loss_function ${losses[$i]} \
										 -b $b -l $l --l1 % $train_data | cut -d$'\t' -f1)
		echo '... tuning l2'
		l2=$(./utl/tuning/vw-hypersearch -L -t $test_data 1e-10 5e-4 vw --loss_function ${losses[$i]} \
										 -b $b -l $l --l1 $l1 --l2 % $train_data | cut -d$'\t' -f1)
	fi
	bcmd+=" -b $b" 
	bcmd+=" -l $l" 
	bcmd+=" --loss_function ${losses[$i]}" 
	if [ "$l1" != "none" ]; then
		bcmd+=" --l1 $l1" 
	fi
	if [ "$l2" != "none" ]; then
		bcmd+=" --l2 $l2" 
	fi
	echo $'\n'
	echo '... training'
	cmd=$bcmd' -d $train_data -f $model_dir/train.${algos[$i]}'
	if [ "${algos[$i]}" == "nn" ]; then
		cmd=$cmd' --nn 10 --inpass'
	fi
	echo $cmd
	eval $cmd
	echo $'\n'
	echo '... testing on train'
	cmd='vw -d $train_data -t -i $model_dir/train.${algos[$i]} -p $pred_dir/${algos[$i]}.train.pred'
	echo $cmd
	eval $cmd
	echo $'\n'
	echo '... testing on test'
	cmd='vw -d $test_data -t -i $model_dir/train.${algos[$i]} -p $pred_dir/${algos[$i]}.test.pred'
	echo $cmd
	eval $cmd
done

# aggregation
paste -d ',' $pred_dir/lr.train.pred $pred_dir/nn.train.pred $pred_dir/svm.train.pred > $pred_dir/all.train.pred
paste -d ',' $pred_dir/lr.test.pred $pred_dir/nn.test.pred $pred_dir/svm.test.pred > $pred_dir/all.test.pred

./utl/ensemble/agg.pl $pred_dir/all.train.pred $pred_dir/a.train.pred
./utl/ensemble/agg.pl $pred_dir/all.test.pred $pred_dir/a.test.pred

# PERFORMANCE
#------------------------------------------------------------------------------
for ((i=0; i < ${#algos[@]}; i++))
do
	echo $'\n'
	echo ${algos[$i]} 
	echo 'logloss train ...'
	./utl/performance/log_loss_computing.pl $train_data $pred_dir/${algos[$i]}.train.pred $perf_dir/${algos[$i]}.train.logloss
	echo 'logloss test ...'
	./utl/performance/log_loss_computing.pl $test_data $pred_dir/${algos[$i]}.test.pred $perf_dir/${algos[$i]}.test.logloss
	echo 'AUC train ...'
	./utl/performance/kdd-perf/perf.src/perf -ROC -files data/train.labels $pred_dir/${algos[$i]}.train.pred > $perf_dir/${algos[$i]}.train.roc
	echo 'AUC test ...'
	./utl/performance/kdd-perf/perf.src/perf -ROC -files data/test.labels $pred_dir/${algos[$i]}.test.pred > $perf_dir/${algos[$i]}.test.roc

done

#rm -f train.labels
#rm -f test.labels

exit 0
