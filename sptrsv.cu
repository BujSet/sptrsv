#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
//#include <hipsparse/hipsparse.h>
#include <stdio.h>

typedef struct {
    int row;
    int col;
    int val;
} Entry_t;


__global__ void helloCUDA() {
    printf("Hello, CUDA!\n");
}
__global__ void vector_add(float *out, float *a, float *b, int n) {
    for(int i = 0; i < n; i++){
        out[i] = a[i] + b[i];
    }
}

int main(){
    std::ifstream input("mawi_201512020330/mawi_201512020330.mtx");
    std::string line;
    // Get the first line
    getline(input, line);
    std::cout << line << std::endl;
    std::stringstream stream(line);
    std::string token;

    getline(stream, token, ' ');
    int nrows = std::stoi(token);
    getline(stream, token, ' ');
    int ncols = std::stoi(token);
    getline(stream, token, ' ');
    int nnz  = std::stoi(token);

    std::cout << "(" << nrows << "," << ncols << ")" << nnz <<std::endl;

//    int row, col;
//    int val;
//    int count = 0;

    // Start parsing the matrix
//    while(getline( input, line )){
//	std::stringstream ss(line);
//	getline(ss, token, ' ');
//	row = std::stoi(token);
//	getline(ss, token, ' ');
//	col = std::stoi(token);
//	getline(ss, token, ' ');
//	val = std::stoi(token);
//	Entry_t *ptr = new Entry_t;
//	ptr->row =row;
//	ptr->col = col;
//	ptr->val = val;
//	count++;
//	v.push_back(ptr);
//	if (row != col) {
//	    // also need to add in the transpose
//	    Entry_t *transpose = new Entry_t;
//	    transpose->row = col;
//	    transpose->col = row;
//	    transpose->val = val;
//	    v.push_back(transpose);
//	    count++;
//	}
//
//    }
//    std::cout << "Found " << count << " nnz entries" << std::endl; 
    helloCUDA<<<1, 1>>>();
    cudaDeviceSynchronize();
    float *a, *b, *out;
    float *d_a, *d_out;

    int N = 10;

    a = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = i*1.0f; 
	b[i] = i*2.0f;
    }

    // Allocate device memory for a
    cudaMalloc((void**)&d_a, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Transfer data from host to device memory
    cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    vector_add<<<1,1>>>(out, d_a, b, N);
    cudaMemcpy(d_out, out, sizeof(float) * N, cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++){
        std::cout << a[i] << "+" << b[i] << "=" << out[i] << std::endl;
    }
    cudaFree(d_a);
    cudaFree(d_out);
    free(a);
    free(b);
    free(out);

    std::cout << "End of program" <<std::endl;
    return 0;
}
