PERF = perf.src

all:
	$(MAKE) -C $(PERF)

span-tree:
	mkdir -p out/model out/predict out/perf

clean_csv:
	rm -f data/csv/headers.csv
	rm -f data/csv/clicks_*.csv
	rm -f data/csv/n_clicks_*.csv
clean_vw:
	rm -f data/vw/*
clean_cache:
	rm -f cache/*
clean_model:
	rm -f model/*
clean_predict:
	rm -f predict/*
clean_perf:
	rm -f $(PERF)/perf

clean_all: clean_csv clean_vw clean_cache clean_model clean_predict clean_perf
