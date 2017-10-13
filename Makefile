PERF = utl/performance/kdd-perf
VARINFO = utl/audit

all: perf varinfo

perf:
	cd ${PERF} && make all
varinfo:
	cd ${VARINFO} && make all

span-tree:
	mkdir -p data/ out/varinfo out/model out/predict out/perf out/cache out/src

clean-csv:
	rm -f data/*csv
clean-vw:
	rm -f data/*vw
clean-labels:
	rm -f data/*labels
clean-cache:
	rm -f out/cache/*
clean-varinfo:
	rm -f out/varinfo/*
clean-model:
	rm -f out/model/*
clean-predict:
	rm -f out/predict/*
clean-src:
	rm -f out/src/*
clean-perf:
	cd ${PERF} && make clean

clean-all: clean-csv clean-vw clean-labels clean-cache clean-varinfo clean-model clean-predict clean-src clean-perf
