
compile: 
	nvcc -O3 MatrixLoader.cpp sptrsv.cu -o sptrsv

clean: 
	rm -f sptrsv

