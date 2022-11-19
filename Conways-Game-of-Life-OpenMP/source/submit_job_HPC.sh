#!/bin/bash
#
# You should only work under the /scratch/users/<username> directory.
#
# Example job submission script
#
# -= Resources =-
#
#SBATCH --job-name=game-of-life-job-bsp 
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --partition=short
#SBATCH --time=00:30:00
#SBATCH --output=game-of-life.out

################################################################################
##################### !!! DO NOT EDIT ABOVE THIS LINE !!! ######################
################################################################################
# Set stack size to unlimited
echo "Setting stack size to unlimited..."
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
echo

echo "Running Job...!"
make clean
make
echo "==============================================================================="
echo "Running compiled binary..."

echo "================================Experiment 1==================================="

echo "Running Parallel Version with 1 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 1
echo "Finished"

echo "Running Parallel Version with 2 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 2
echo "Finished"

echo "Running Parallel Version with 4 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 4
echo "Finished"

echo "Running Parallel Version with 8 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 8
echo "Finished"

echo "Running Parallel Version with 16 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 16
echo "Finished"

echo "Running Parallel Version with 32 Thread"
export KMP_AFFINITY=verbose,granularity=fine,compact
export OMP_NESTED=true
./life -n 2000 -i 500 -p 0.2 -d -t 32
echo "Finished"

echo "================================Experiment 2==================================="

echo "Running Parallel Version with input size 2000"
./life -n 2000 -i 500 -p 0.2 -d -t 16
echo "Finished"


echo "Running Parallel Version with input size 4000"
./life -n 4000 -i 500 -p 0.2 -d -t 16
echo "Finished"


echo "Running Parallel Version with input size 6000"
./life -n 6000 -i 500 -p 0.2 -d -t 16
echo "Finished"


echo "Running Parallel Version with input size 8000"
./life -n 8000 -i 500 -p 0.2 -d -t 16
echo "Finished"


echo "Running Parallel Version with input size 10000"
./life -n 10000 -i 500 -p 0.2 -d -t 16
echo "Finished"

echo "=============================FINISH======================================"
echo "=============================FINISH======================================"



