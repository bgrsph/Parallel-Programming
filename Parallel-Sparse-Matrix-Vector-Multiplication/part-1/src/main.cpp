// SpMV Code
// Created: 03-12-2019
// Author: Najeeb Ahmad
// Updated: 13-05-2020
// Author: Muhammad Aditya Sasongko
// Author: Buğra Sipahioğlu

#include <bits/stdc++.h>
#include "common.h"
#include "matrix.h"
#include "mmio.h"
#include <mpi.h>

using namespace std;
#define MASTER 0


int main(int argc, char **argv)
{
    // BUĞRA: Define Variables
    int numOfProcessors;
    int numOfTotalRows;   
    int time_steps; 
    double *rhs; 
    double *result;
    double tempResult;

    // BUĞRA: Variables that are private to a process
    int myRank; //local id of a process
    int myRowCount;  // number of rows per process
    int *myRowPtr;  // local row pointer per process
    int *myColPtr;  // local column pointer per process
    double *myValptr;  // local value pointer per process
    int myNumOfTotalRows; // copy per process
    int myTimeSteps; // copy per process
    double *myLocalResult; 
    int myNnz; // number of non zero elements per process
    int myNnzDisplacements; // Displacements are for irregular message sizes due to CSR format.

    // BUĞRA: Initialize the MPI environment
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &myRank);
    MPI_Comm_size(MPI_COMM_WORLD, &numOfProcessors);

    // BUĞRA: Master process distributes special information per process in the array, then it will scatter the info to processes using mpi_scatter. 
    int nnzList[numOfProcessors];
    int localRowCountsList[numOfProcessors];
    int rowDisplacementsList[numOfProcessors];
    int nnzDisplacementList[numOfProcessors];
    int numOfTotalRowsList[numOfProcessors];
    int timeStepsList[numOfProcessors];

    csr_matrix matrix;
    string matrix_name;

    if (myRank == MASTER)  // BUĞRA: Master should distribute the information and handle the initial phase of the code.
    {
        if(argc < 3)
        {
    	    std::cout << "Error: Missing arguments\n";
    	    std::cout << "Usage: " << argv[0] << " matrix.mtx\n" << " time_step_count";
    	    return EXIT_FAILURE;
        }

        printf("Reading .mtx file\n");
        int retCode = 0;
        time_steps = atoi(argv[2]);
        matrix_name = argv[1];
        cout << matrix_name << endl;

        retCode = mm_read_unsymmetric_sparse(argv[1], &matrix.m, &matrix.n, &matrix.nnz, &matrix.csrVal, &matrix.csrRowPtr, &matrix.csrColIdx);
        if(retCode == -1)
        {
	        cout << "Error reading input .mtx file\n";
	        return EXIT_FAILURE;
        }

        numOfTotalRows = matrix.m;  
        rhs = (double *)malloc(sizeof(double) * matrix.n);

        printf("Matrix Rows: %d\n", matrix.m);
        printf("Matrix Cols: %d\n", matrix.n);
        printf("Matrix nnz: %d\n", matrix.nnz);
        coo2csr_in(matrix.m, matrix.nnz, matrix.csrVal, matrix.csrRowPtr, matrix.csrColIdx);
        printf("Done reading file\n");

        for(int i = 0; i < matrix.n; i++)
        {
            rhs[i] = (double) 1.0/matrix.n;
        }

        // BUĞRA: It is assummed.
        if (numOfTotalRows % numOfProcessors != 0) {
            cout << "Number of rows should be multiple of number of processors" << endl;
            return EXIT_FAILURE;
        }

        myRowCount = (int) numOfTotalRows/numOfProcessors;

        // BUĞRA: Distribute the data to arrays; Array[i] means Process i.
        for (int i = 0; i < numOfProcessors; i++ ) {
            localRowCountsList[i] = myRowCount;
            numOfTotalRowsList[i] = numOfTotalRows;
            timeStepsList[i] = time_steps;
            nnzList[i] = matrix.csrRowPtr[i * myRowCount + localRowCountsList[i]] - matrix.csrRowPtr[i * myRowCount];
            nnzDisplacementList[i] = matrix.csrRowPtr[i * myRowCount];
            rowDisplacementsList[i] = i * myRowCount;
        }
    }


    // BUĞRA: Scatter all the arrays above to all processes, hold the information in local variables (myVariable)
    MPI_Scatter( numOfTotalRowsList, 1, MPI_INT, &myNumOfTotalRows, 1, MPI_INT, MASTER, MPI_COMM_WORLD);    
    MPI_Scatter( timeStepsList, 1, MPI_INT, &myTimeSteps, 1, MPI_INT, MASTER, MPI_COMM_WORLD);
    MPI_Scatter( nnzList, 1, MPI_INT, &myNnz, 1, MPI_INT, MASTER, MPI_COMM_WORLD);
    MPI_Scatter( nnzDisplacementList, 1, MPI_INT, &myNnzDisplacements, 1, MPI_INT, MASTER, MPI_COMM_WORLD);

    // BUĞRA: All the processes need to allocate memory for rhs, master did it already.
    if(myRank != MASTER){
        rhs = (double*)malloc(sizeof(double) * myNumOfTotalRows);
    }
    myLocalResult = (double*)malloc(sizeof(double) * myNumOfTotalRows);
    result = (double*)malloc(sizeof(double) * myNumOfTotalRows);
    

    // BUĞRA: Broadcast the arrays which will be used by all processes
    MPI_Bcast(localRowCountsList, numOfProcessors, MPI_INT, MASTER, MPI_COMM_WORLD);
    myRowCount = localRowCountsList[myRank];
    MPI_Bcast(rowDisplacementsList, numOfProcessors, MPI_INT, MASTER, MPI_COMM_WORLD);
    MPI_Bcast(rhs, myNumOfTotalRows, MPI_DOUBLE, MASTER, MPI_COMM_WORLD);
    

    // BUĞRA: After getting all the data, assign memory space for CSR entries
    myRowPtr = (int*)malloc(sizeof(int) * (myRowCount + 1));
    myColPtr = (int*)malloc(sizeof(int) * myNnz);
    myValptr = (double*)malloc(sizeof(double) * myNnz);

    // BUĞRA: Scatter CSR entries to all processes
    MPI_Scatterv(matrix.csrRowPtr, localRowCountsList, rowDisplacementsList, MPI_INT, myRowPtr, myRowCount, MPI_INT, MASTER, MPI_COMM_WORLD);
    MPI_Scatterv(matrix.csrColIdx, nnzList, nnzDisplacementList, MPI_INT, myColPtr, myNnz, MPI_INT, MASTER, MPI_COMM_WORLD);
    MPI_Scatterv(matrix.csrVal, nnzList, nnzDisplacementList, MPI_DOUBLE, myValptr, myNnz, MPI_DOUBLE, MASTER, MPI_COMM_WORLD);


    // cout << "rank " << myRank << ", total rows: " << myNumOfTotalRows<<", my row count " << myRowCount << ", localRowCountsList: " << localRowCountsList << ", row disp list: " << rowDisplacementsList << ", rhs: " << rhs << endl;
    // MPI_Finalize();
    // return 0;

    // BUĞRA: Start the computation; basically copy the serial execution with local pointers only.
    clock_t start, end;
    start = clock();

    for (int k = 0; k < myTimeSteps; k++) {

        for (int i = 0; i < myRowCount; i++) {

            if (i+1 == myRowCount) {
                myRowPtr[i + 1] = myRowPtr[0] + myNnz;
            }

            tempResult = 0.0;

            for (int j = myRowPtr[i]; j < myRowPtr[i + 1]; j++) {
                tempResult += myValptr[j - myNnzDisplacements] * rhs[myColPtr[j - myNnzDisplacements]];
            }

            myLocalResult[i] = tempResult;
        }

        // BUĞRA: For the next iteration, update all the other processes
        MPI_Allgatherv(myLocalResult, myRowCount, MPI_DOUBLE, result, localRowCountsList, rowDisplacementsList, MPI_DOUBLE, MPI_COMM_WORLD);
        //   cout << "rank " << myRank << ", total rows: " << myNumOfTotalRows<<", my row count " << myRowCount << ", localRowCountsList: " << localRowCountsList << ", row disp list: " << rowDisplacementsList << ", rhs: " << rhs << endl;

        for(int i = 0; i < myNumOfTotalRows; i++)
      	{
		    rhs[i] = result[i];
      	}

    }

    end = clock(); 
    MPI_Finalize();

    if (myRank == MASTER) {

        double time_taken = double(end - start) / double(CLOCKS_PER_SEC); 
        cout << "Time taken by program is : " << fixed  
        << time_taken << setprecision(5); 
        cout << " sec " << endl;  

        for(int i = 0; i < myNumOfTotalRows; i++)
            cout << rhs[i] << endl;
    }
    return EXIT_SUCCESS;
}