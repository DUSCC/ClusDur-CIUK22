#!/bin/bash

mkdir stream
cd stream
curl https://www.cs.virginia.edu/stream/FTP/Code/stream.c -o stream.c
gcc -O3 -fopenmp stream.c -o stream
OMP_NUM_THREADS=64 ./stream > ~/results/stream_results.txt
cd ~
