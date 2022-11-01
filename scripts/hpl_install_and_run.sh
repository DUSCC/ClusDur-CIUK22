#!/bin/bash
sudo yum install git -y
sudo yum install wget -y
sudo yum install make -y

#install OpenMPI
sudo yum install openmpi -y
sudo yum install openmpi-devel -y
export PATH=/usr/lib64/openmpi/bin:$PATH

#build and install OpenBLAS
git clone https://github.com/xianyi/OpenBLAS.git 
cd OpenBLAS
make -j 20
make PREFIX=../install_openblas install
cd ~

#build and install HPL
wget http://www.netlib.org/benchmark/hpl/hpl-2.3.tar.gz
tar xf hpl-2.3.tar.gz
cp Make.intel64 ./hpl-2.3
cd hpl-2.3
#TODO Workflow: copy Make.intel64 from login node ~/results_hpl/Make.intel64 to /home/centos/hpl-2.3 on compute node
make arch=intel64
cd bin/intel64
cp ~/HPL128.dat ./HPL.dat
#TODO Workflow: copy HPL.dat from login node ~/results_hpl/HPL.dat to /home/centos/hpl-2.3/bin/intel64 on compute node
#run HPL; output is written to HPL.out as specified in HPL.dat
mpirun -n 128 -bind-to core ./xhpl
mv HPL.out ~/results/HPL128.txt

cp ~/HPL1.dat ./HPL.dat
mpirun -n 1 -bind-to core ./xhpl
mv HPL.out ~/results/HPL1.txt

cd ~
