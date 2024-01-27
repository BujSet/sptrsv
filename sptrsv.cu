#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <cassert>
#include <sstream>
#include <stdio.h>
#include <algorithm>
#include "MatrixLoader.hpp"

bool compareByRow(const Entry_t *elem1, const Entry_t *elem2 ) {
    if (elem1->row == elem2->row) {
        return elem1->col < elem2->col;
    }
    return elem1->row < elem2->row;
}

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int i = threadIdx.x + blockDim.x * threadIdx.y;
    if (i < n) {
        out[i] = a[i] + b[i]; 
    }
}

int main(){
//    std::ifstream input("mawi_201512020330/mawi_201512020330.mtx");
    std::ifstream input("arc130/arc130.mtx");
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

    MatrixLoader *myld = new MatrixLoader("arc130/arc130.mtx", 3.959802e-31);


    int row, col;
    float val;
    int count = 0;
    std::vector<Entry_t*> v;
    // Start parsing the matrix
    while(getline( input, line )){
	std::stringstream ss(line);
	getline(ss, token, ' ');
	row = std::stoi(token);
	getline(ss, token, ' ');
	col = std::stoi(token);
	getline(ss, token, ' ');
	val = std::stof(token);
	if (std::abs(val) < 3.959802e-31) {
	    printf("Skipping value =%f\n", val);
            continue;
	}
	Entry_t *ptr = new Entry_t;
	ptr->row =row;
	ptr->col = col;
	ptr->val = val;
	count++;
	v.push_back(ptr);
    }
    std::sort(v.begin(), v.end(), &compareByRow);
    std::cout << "Found " << count << " nnz entries" << std::endl; 
    for(Entry_t *ptr : v) {
        std::cout << "(" << ptr->row << "," << ptr->col << ")=" << ptr->val << std::endl;
    }
    int *csrRowPtrs = (int*)malloc(sizeof(int)*nnz);
    int *csrColIdxs = (int*)malloc(sizeof(int)*nnz);
    float *csrVals = (float*)malloc(sizeof(float)*nnz);
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
    free(csrRowPtrs);
    free(csrColIdxs);
    free(csrVals);
    free(out);

    for (Entry_t *ptr : v) {
        delete ptr;
    }
    delete myld;
    std::cout << "End of program" <<std::endl;
    return 0;
}
