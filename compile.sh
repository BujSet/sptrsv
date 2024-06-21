#!/bin/bash

set -e

if [ $2 == "profile" ];
then
PROFILEFLAG=-DPROFILE
fi

echo "Compiling ${KERNEL_NAME}"
infile=$1.cpp
outbin=$1

ROCSHMEM_PATH=/root

#-save-temps=./tmp \
echo $PWD 
hipcc \
${COMPILEFLAG} \
${PROFILEFLAG} \
-I/opt/rocm/include/ \
-I$PWD \
-D__HIP_HCC_COMPAT_MODE__=1 \
${DEBUGFLAG} \
-fgpu-rdc \
-c ${infile} -o build/$1.o

hipcc \
${COMPILEFLAG} \
${PROFILEFLAG} \
-I/opt/rocm/include/ \
-I$PWD \
-D__HIP_HCC_COMPAT_MODE__=1 \
${DEBUGFLAG} \
-fgpu-rdc \
-c MatrixLoader.cpp -o build/MatrixLoader.o

hipcc -v ${COMPILEFLAG} -L/opt/rocm/lib -L/opt/rocm/hip/lib  -I$PWD -D__HIP_HCC_COMPAT_MODE__=1 ${DEBUGFLAG} -fgpu-rdc --hip-link build/MatrixLoader.o build/sptrsv.o -o a.out -lhsa-runtime64 -lamdhip64 
