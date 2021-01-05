.PHONY: all book push clean commit
.SECONDARY: stage-5.tgz stage-5/.sentinel

EXT?=tgz

all:  book
push: book
	docker push     innovanon/$<
book: stage-5.$(EXT)
	docker build -t innovanon/$@ $(TEST) .
commit:
	git add .
	git commit -m '[Makefile] commit'
	git pull
	git push

stage-5.tgz: stage-5/.sentinel
	cd $(shell dirname $<) && \
	tar acvf ../$@ # --owner=0 --group=0 .

stage-5/.sentinel: $(shell find stage-5 -type f)
	openssl rand -out $@ $(shell echo '2 ^ 10' | bc )
	#touch $@

clean:
	rm -vf stage-*.$(EXT) */.sentinel .sentinel

