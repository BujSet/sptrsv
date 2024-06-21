#include <iostream>
#include <vector>
#include <fstream>
#include <string>
#include <cassert>
#include <sstream>
#include <stdio.h>
#include <algorithm>
#include "MatrixLoader.hpp"
#include <hip/hip_runtime.h>
#include <hsa/hsa.h>
#include <hsa/hsa_ext_amd.h>
#include "check_err.h"

__global__ void vector_add(float *out, float *a, float *b, int n) {
    int i = threadIdx.x + blockDim.x * threadIdx.y;
    if (i < n) {
        out[i] = a[i] + b[i]; 
    }
}

int main(){
    //MatrixLoader *myld = new MatrixLoader("arc130/arc130.mtx", 3.959802e-31);
    //myld->printConfigs();
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

    // Allocate device memory for a
    CHECK_HIP_ERROR(hipMalloc((void**)&d_a, sizeof(float) * N));
    CHECK_HIP_ERROR(hipMalloc((void**)&d_b, sizeof(float) * N));
    CHECK_HIP_ERROR(hipMalloc((void**)&d_out, sizeof(float) * N));

    // Transfer data from host to device memory
    CHECK_HIP_ERROR(hipMemcpy(d_a, a, sizeof(float) * N, hipMemcpyHostToDevice));
    CHECK_HIP_ERROR(hipMemcpy(d_b, b, sizeof(float) * N, hipMemcpyHostToDevice));
    hipLaunchKernelGGL(vector_add, 1, 256, 0, 0, d_out, d_a, d_b, N);
    CHECK_HIP_ERROR(hipMemcpy(out, d_out, sizeof(float) * N, hipMemcpyDeviceToHost));
    for (int i = 0; i < N; i++){
        std::cout << a[i] << "+" << b[i] << "=" << out[i] << std::endl;
    }
    CHECK_HIP_ERROR(hipFree(d_a));
    CHECK_HIP_ERROR(hipFree(d_b));
    CHECK_HIP_ERROR(hipFree(d_out));
    free(a);
    free(b);
    free(out);

    //delete myld;
    std::cout << "End of program" <<std::endl;
    return 0;
}
