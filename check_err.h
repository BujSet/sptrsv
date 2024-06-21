#ifndef __CHECK_ERR_H__
#define __CHECK_ERR_H__
#include <assert.h>
#include <stdio.h>

//fprintf(stderr, "%s : %d HIP Error: %d, %s, %s\n", __FILE__, __LINE__ val, hipGetErrorName(val), hipGetErrorString(val)); 
#define CHECK_HIP_ERROR(val)  errCheck(val, __FILE__, __LINE__);
inline void errCheck(hipError_t errCode, const char* fname, int lno) {
    if  (errCode != hipSuccess) {
        fprintf(stderr, "%s : %d HIP Error: %d ,%s, %s\n", fname, lno, errCode, hipGetErrorName(errCode), hipGetErrorString(errCode));
        assert(0);
    }
}

#define CHECK_HSA_ERROR(val)  errCheck(val, __FILE__, __LINE__);
inline void errCheck(hsa_status_t errCode, const char* fname, int lno) {
    if  (errCode != HSA_STATUS_SUCCESS) {
        fprintf(stderr, "%s : %d HSA Error: 0x%x \n", fname, lno, errCode);
        assert(0);
    }
}

#define NCCLCHECK(cmd) do {                         \
  ncclResult_t r = cmd;                             \
  if (r!= ncclSuccess) {                            \
    printf("Failed, NCCL error %s:%d '%s'\n",             \
        __FILE__,__LINE__,ncclGetErrorString(r));   \
    exit(EXIT_FAILURE);                             \
  }                                                 \
} while(0)
#endif
