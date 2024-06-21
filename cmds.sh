# Get rocm docker 6.0.2 (currently tested)
docker pull rocm/rocm-terminal:6.0.2

# run the container and mount necessary directories
# mount rocshmem directory and scripts in the container
docker run -it --rm \
--privileged \
--network=host \
--ipc=host \
--user root \
--device=/dev/kfd \
--device=/dev/dri \
--security-opt seccomp=unconfined \
--mount type=bind,source=/home/bselagam/sptrsv,target=/home/rocm-user \
--group-add video \
--name=bselagam_rocm_sptrsv \
rocm/rocm-terminal:6.0.2

groups

# install dependencies within docker container
sudo apt-get update
sudo apt-get install -y autoconf libtool
python3 -m pip install matplotlib

# install ucx and mpich
# ucx and mpich will be installed in home directory /home/rocm-user in above container
#./download_and_install.sh ucx
#./download_and_install.sh mpich
#./download_and_install.sh rccl

# setup environment variables
# check/modify $MPI_HOME, $UCX_HOME if installed at a different location
#source setup_env.sh

# Use the shmem directory provided for now
# there are some changes which have not been
# pushed into amd internal rocshmem repo. Will be done soon
# compile and install rocshmem
# Check if /root/rocshmem/lib/librocshmem.a is created, ignore other warnings
#./test_rocshmem.sh

#mkdir -p build/
#mkdir -p profTrace/

./compile.sh persistentFusedGemm_allReduce
#
#rocm-smi --setperflevel high
#mpirun -np 4 ./a.out

#rocm-smi && rocm-smi --setperflevel high && sleep 5 && mpirun -np 4 ./a.out && rocm-smi --setperflevel low && rocm-smi
