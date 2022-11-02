#!/bin/sh

cd ~/
mkdir gromacs-challenge-cpu
cd gromacs-challenge-cpu

echo "downloading files"
wget https://ftp.gromacs.org/gromacs/gromacs-2022.2.tar.gz
wget ftp://ftp.gromacs.org/pub/benchmarks/water_GMX50_bare.tar.gz

echo "untarring files"
tar -xf gromacs-2022.2.tar.gz
tar -xf water_GMX50_bare.tar.gz

echo "moving to cmake directory"
mkdir build
mkdir compiled
cd build

echo "cmaking"
cmake ../gromacs-2022.2 -DGMX_MPI=OFF -DGMX_OPENMP=ON -DGMX_BUILD_OWN_FFTW=ON -DCMAKE_INSTALL_PREFIX=~/gromacs-challenge-cpu/compiled

echo "compiling"
make install -j

echo "moving to test directory"
cd ../water-cut1.0_GMX50_bare/1536

echo "converting pme.mdp to bench.tpr"
# use grompp to convert pme.mdp to bench.tpr (Must run from within water_gmx50/1536)
~/gromacs-challenge-cpu/compiled/bin/gmx grompp -f pme.mdp -o bench.tpr

echo "running simulation"
# run with
~/gromacs-challenge-cpu/compiled/bin/gmx mdrun -nsteps 1000 -v -g -s bench.tpr
lscpu >> ~/gromacs-challenge-cpu/water-cut1.0_GMX50_bare/1536/md.log
mv ~/gromacs-challenge-cpu/water-cut1.0_GMX50_bare/1536/md.log ~/gromacs-challenge-cpu/gromacs-cpu-results.txt
