PERF = utl/performance/kdd-perf

all: perf

perf:
	cd ${PERF} && make all

span-tree:
	mkdir -p out/varinfo out/model out/predict out/perf out/cache

clean-csv:
	rm -f data/*csv
clean-vw:
	rm -f data/*vw
clean-cache:
	rm -f out/cache/*
clean-varinfo:
	rm -f out/varinfo/*
clean-model:
	rm -f out/model/*
clean-predict:
	rm -f out/predict/*
clean-perf:
	cd ${PERF} && make clean

clean-all: clean-csv clean-vw clean-cache clean-varinfo clean-model clean-predict clean-perf
