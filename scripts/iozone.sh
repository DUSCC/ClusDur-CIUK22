#!/bin/bash

cd /home/centos
mkdir iozone
cd iozone
curl https://www.iozone.org/src/current/iozone3_493.tgz -o iozone3_493.tgz
tar -xf iozone3_493.tgz
cd ./iozone3_493/src/current
make linux
OMP_NUM_THREADS=1 ./iozone -t 1 -i 0 -s 10G -r 1M -w -e > /home/centos/results/iozone_w_1.txt
OMP_NUM_THREADS=1 ./iozone -t 1 -i 1 -s 10G -r 1M -w -e > /home/centos/results/iozone_r_1.txt
rm iozone.DUMMY*
OMP_NUM_THREADS=32 ./iozone -t 32 -i 0 -s 156M -r 1M -w -e > /home/centos/results/iozone_w_32.txt
OMP_NUM_THREADS=32 ./iozone -t 32 -i 1 -s 156M -r 1M -w -e > /home/centos/results/iozone_r_32.txt
rm iozone.DUMMY*
