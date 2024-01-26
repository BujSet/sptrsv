
compile: 
	nvcc -O3 sptrsv.cu -o sptrsv

clean: 
	rm -f sptrsv

