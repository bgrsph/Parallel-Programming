#!/bin/bash
#
# You should only work under the /scratch/users/<username> directory.
#
# Example job submission script
#
# -= Resources =-
#
#SBATCH --job-name=nqueens-job 
#SBATCH --exclusive
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=16
#SBATCH --partition=short
#SBATCH --time=00:30:00
#SBATCH --output=nqueens-full-test-results.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=bsipahioglu15@ku.edu.tr

################################################################################
##################### !!! DO NOT EDIT ABOVE THIS LINE !!! ######################
################################################################################
echo "================================N Queens Parallelization Test==================================="
# Set stack size to unlimited
echo "Setting stack size to unlimited..."
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
echo

module load /kuacc/etc/mod/openmpi/4.0.1
module load intel/ipsxe2019-u1ce
module load gcc/7.2.1/gcc



echo "================================Scalability Test==================================="

echo "================================PART 2-A==========================================="


echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_1.c -o serial_1

echo "Running Serial Version"
./serial_1
rm serial_1
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_1.c -o parallel_1
echo ""

echo "Running Parallel Version with 1 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_1
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_1
rm parallel_1
echo "Finished"
echo ""
echo "=============================PART 2-A FINISHED ======================================"

echo ""
echo ""

echo "================================PART 2-B==========================================="

echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_1.c -o serial_1

echo "Running Serial Version"
./serial_1
rm serial_1
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_2.c -o parallel_2
echo ""

echo "Running Parallel Version with 1 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_2
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_2
rm parallel_2
echo "Finished"
echo ""
echo "=============================PART 2-B FINISHED ======================================"

echo ""
echo ""

echo "================================PART 2-C==========================================="

echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_3.c -o serial_3

echo "Running Serial Version"
./serial_3
rm serial_3
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_3.c -o parallel_3
echo ""

echo "Running Parallel Version with 1 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_3
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_3
rm parallel_3
echo "Finished"
echo ""
echo "=============================PART 2-C FINISHED ======================================"
echo "=============================Scalibility Test FINISHED ======================================"

echo ""
echo ""

echo "=============================Thread Bining Test======================================"

echo "================================PART 2-A==========================================="


echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_1.c -o serial_1

echo "Running Serial Version"
./serial_1
rm serial_1
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_1.c -o parallel_1
echo ""

echo "Running Parallel Version with 1 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_1
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_1
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_1
rm parallel_1
echo "Finished"
echo ""
echo "=============================PART 2-A FINISHED ======================================"

echo ""
echo ""

echo "================================PART 2-B==========================================="

echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_1.c -o serial_1

echo "Running Serial Version"
./serial_1
rm serial_1
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_2.c -o parallel_2
echo ""

echo "Running Parallel Version with 1 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_2
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_2
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread and Cutoff Parameter"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_2
rm parallel_2
echo "Finished"
echo ""
echo "=============================PART 2-B FINISHED ======================================"

echo ""
echo ""

echo "================================PART 2-C==========================================="

echo "Compiling serial code..."
gcc -fopenmp nqueens_serial_3.c -o serial_3

echo "Running Serial Version"
./serial_3
rm serial_3
echo "Finished"
echo ""

echo "Compiling parallel code..."
gcc -fopenmp nqueens_parallel_3.c -o parallel_3
echo ""

echo "Running Parallel Version with 1 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=1
./parallel_3
echo "Finished"
echo ""


echo "Running Parallel Version with 2 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=2
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 4 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=4
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 8 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=8
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 16 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=16
./parallel_3
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread and One Solution"
export GMP_AFFINITY=granularity=fine,scatter
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_3
rm parallel_3
echo "Finished"
echo ""
echo "=============================PART 2-C FINISHED ======================================"

echo "=============================Thread Bining Test FINISHED ======================================"

echo ""
echo ""

echo "=============================Problem Size Test======================================"

echo "Compiling parallel codes..."
gcc -fopenmp nqueens_parallel_c_13.c -o parallel_13
gcc -fopenmp nqueens_parallel_c_14.c -o parallel_14
gcc -fopenmp nqueens_parallel_c_15.c -o parallel_15

echo ""

echo "Running Parallel Version with 32 Thread & Problem Size 13"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_13
echo "Finished"
echo ""


echo "Running Parallel Version with 32 Thread & Problem Size 14"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_14
echo "Finished"
echo ""

echo "Running Parallel Version with 32 Thread & Problem Size 15"
export GMP_AFFINITY=granularity=fine,compact
export OMP_NESTED=true
export OMP_DYNAMIC=false
export OMP_NUM_THREADS=32
./parallel_15
rm parallel_13
rm parallel_14
rm parallel_15
echo "Finished"
echo ""
echo "=============================Problem Size Test FINISHED======================================"


echo "================================N Queens Parallelization Test FINISHED==================================="