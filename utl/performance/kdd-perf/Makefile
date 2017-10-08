all: get-perf xtract-perf compile-perf

get-perf:
	wget http://osmot.cs.cornell.edu/kddcup/perf/perf.src.tar.gz
xtract-perf:
	tar -xvzf perf.src.tar.gz
	rm perf.src.tar.gz
compile-perf:
	rm perf.src/perf
	sed -ie 's/MAX_ITEMS\ 500000/MAX_ITEMS\ 50000000/' perf.src/perf.c
	cd perf.src && make perf
clean:
	rm -rf perf.src
