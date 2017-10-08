all: data-gen sanity-check

data-gen:
	./generate-trainset.pl > ../../data/sanity-sample.vw
sanity-check:
	./vw-varinfo --noconstant ../../data/sanity-sample.vw
clean:
	rm ../../data/sanity-sample.vw
