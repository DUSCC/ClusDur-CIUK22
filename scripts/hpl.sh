#!/bin/bash

export PATH=$PATH:/usr/lib64/openmpi/bin
#build and install OpenBLAS
git clone -q https://github.com/xianyi/OpenBLAS.git
cd OpenBLAS
make -j 20
make PREFIX=../install_openblas install
cd /home/centos

#build and install HPL
wget http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz
tar xf hpl-2.3.tar.gz
cp Make.intel64 ./hpl-2.3
cd hpl-2.3

make arch=intel64
cd bin/intel64
cp ~/HPL128.dat ./HPL.dat

#run HPL; output is written to HPL.out as specified in HPL.dat
mpirun -n 128 -bind-to core ./xhpl
mv HPL.out ~/results/HPL128.txt

cp ~/HPL1.dat ./HPL.dat
mpirun -n 1 -bind-to core ./xhpl
mv HPL.out ~/results/HPL1.txt

cd /home/centos
