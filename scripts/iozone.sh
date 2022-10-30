#!/bin/bash

mkdir iozone
cd iozone
curl https://www.iozone.org/src/current/iozone3_493.tgz -o iozone3_493.tgz
tar -xf iozone3_493.tgz
cd ./iozone3_493/src/current
make linux
OMP_NUM_THREADS=64 ./iozone -a >> ~/results/iozone_results.txt
cd ~
