#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <cassert>
#include <sstream>
#include <stdio.h>

typedef struct {
    int row;
    int col;
    int val;
} Entry_t;

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int i = threadIdx.x + blockDim.x * threadIdx.y;
    if (i < n) {
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
    float *a, *b, *out;
    float *c, *d;
    float *d_a, *d_b, *d_out;

    int N = 10;

    a = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    c = (float*)malloc(sizeof(float) * N);
    d   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = i*1.0f; 
	b[i] = i*2.0f;
    }
    for(int i = 0; i < N; i++){
        printf("a=%f,b=%f\n", a[i], b[i]);
    }

    cudaError_t result;
    // Allocate device memory for a
    result = cudaMalloc((void**)&d_a, sizeof(float) * N);
    assert(result == cudaSuccess);
    cudaMalloc((void**)&d_b, sizeof(float) * N);
    cudaMalloc((void**)&d_out, sizeof(float) * N);

    // Transfer data from host to device memory
    result = cudaMemcpy(d_a, a, sizeof(float) * N, cudaMemcpyHostToDevice);
    assert(result == cudaSuccess);
    cudaMemcpy(d_b, b, sizeof(float) * N, cudaMemcpyHostToDevice);
    cudaMemcpy(c, d_a, sizeof(float) * N, cudaMemcpyDeviceToHost);
    cudaMemcpy(d, d_b, sizeof(float) * N, cudaMemcpyDeviceToHost);
    for(int i = 0; i < N; i++){
        printf("c=%f,d=%f\n", c[i], d[i]);
    }
    vector_add<<<1,256>>>(d_out, d_a, d_b, N);
    cudaMemcpy(out, d_out, sizeof(float) * N, cudaMemcpyDeviceToHost);
    for (int i = 0; i < N; i++){
        std::cout << a[i] << "+" << b[i] << "=" << out[i] << std::endl;
    }
    cudaFree(d_a);
    cudaFree(d_b);
    cudaFree(d_out);
    free(a);
    free(b);
    free(c);
    free(d);
    free(out);

    std::cout << "End of program" <<std::endl;
    return 0;
}
