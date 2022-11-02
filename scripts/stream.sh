#!/bin/bash

cd /home/centos
mkdir stream
mv stream.c stream
cd stream
gcc -O3 -fopenmp stream.c -o stream
OMP_NUM_THREADS=32 ./stream > /home/centos/results/stream_results.txt
cd /home/centos
