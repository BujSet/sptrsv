
compile: 
	hipcc -O3 sptrsv.cu -o sptrsv -lhipsparse

clean: 
	rm -f sptrsv

