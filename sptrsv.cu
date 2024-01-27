#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <cassert>
#include <sstream>
#include <stdio.h>
#include <algorithm>
#include "MatrixLoader.hpp"

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int i = threadIdx.x + blockDim.x * threadIdx.y;
    if (i < n) {
        out[i] = a[i] + b[i]; 
    }
}

int main(){
    MatrixLoader *myld = new MatrixLoader("arc130/arc130.mtx", 3.959802e-31);
    myld->printConfigs();
    float *a, *b, *out;
    float *d_a, *d_b, *d_out;

    int N = 10;

    a = (float*)malloc(sizeof(float) * N);
    b   = (float*)malloc(sizeof(float) * N);
    out = (float*)malloc(sizeof(float) * N);

    // Initialize array
    for(int i = 0; i < N; i++){
        a[i] = i*1.0f; 
	b[i] = i*2.0f;
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
    free(out);

    delete myld;
    std::cout << "End of program" <<std::endl;
    return 0;
}
