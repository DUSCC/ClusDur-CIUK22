#!/bin/bash

cd /home/centos
mkdir fhourstones
cd fhourstones
git clone https://github.com/qu1j0t3/fhourstones.git
cd fhourstones
gcc -O3 SearchGame.c -o SearchGame
./SearchGame < inputs > /home/centos/results/fhourstones_test.dat
