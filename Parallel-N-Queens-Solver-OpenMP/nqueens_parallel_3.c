#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h> 
#include <string.h>
#include <omp.h>

#define N 14
bool SOLUTION_EXISTS = false;


bool can_be_placed(int board[N][N], int row, int col);
void print_solution(int board[N][N]);
bool solve_NQueens(int board[N][N], int col);


bool can_be_placed(int board[N][N], int row, int col) 
{ 
    int i, j; 
  
    /* Check this row on left side */
    for (i = 0; i < col; i++) 
        if (board[row][i]) 
            return false; 
  
    /* Check upper diagonal on left side */
    for (i=row, j=col; i>=0 && j>=0; i--, j--) 
        if (board[i][j]) 
            return false; 
  
    /* Check lower diagonal on left side */
    for (i=row, j=col; j>=0 && i<N; i++, j--) 
        if (board[i][j]) 
            return false; 
  
    return true; 
} 

void print_solution(int board[N][N]) 
{ 
    static int k = 1; 
    int i,j; /* BUGRA: C version in the cluster doesn't support definition in for loop */

    printf("Solution #%d-\n",k++); 
    for (i = 0; i < N; i++) 
    { 
        for (j = 0; j < N; j++)
        {
            printf(" %d ", board[i][j]); 
        } 
        printf("\n"); 
    } 
    printf("\n"); 
} 

bool solve_NQueens(int board[N][N], int col) 
{ 

    bool atom = SOLUTION_EXISTS;
    
    #pragma omp critical
    {
        atom = SOLUTION_EXISTS;
    }

    if(atom)
    {
        return true;
    }
    

    /* BUGRA: Each task should work on it's own local board (as matrix) in order to find correct solutions */
    int local_board[N][N];
    memcpy(local_board,board,sizeof(local_board));
    int i;

    if (col == N) 
    { 
        /* BUGRA: SOLUTION_EXISTS is a global variable, open to race condition. Actions should be atomic */
        #pragma omp critical
        {
            /* BUGRA: No need to print for every test */
            print_solution(local_board); 
            SOLUTION_EXISTS = true;
        }

        return true; 
    } 
  
    for (i = 0; i < N; i++) 
    { 
            if ( can_be_placed(local_board, i, col)) 
            { 
                local_board[i][col] = 1; 
                /* BUGRA: No need to calculate SOLUTION_EXISTS in here since upper if statement already does that. */
                #pragma omp task default(none) firstprivate(col,local_board)
                {
                    solve_NQueens(local_board, col + 1);
                }
                local_board[i][col] = 0;  
            } 
    } 
}


int main() 
{ 
    int board[N][N]; 
    memset(board, 0, sizeof(board)); 
    double time1 = omp_get_wtime();

    /* BUGRA: function should be called only once, and each task should wait its' children tasks, which is done by taskgroup */
    #pragma omp parallel default(none) shared(board)
    {
        #pragma omp single
        {
            #pragma omp taskgroup
            {
                solve_NQueens(board, 0);
            }
        }
    }
    

    if (SOLUTION_EXISTS == false) 
    { 
        printf("No Solution Exits! \n"); 
    } 
    printf("Elapsed time: %0.2lf\n", omp_get_wtime() - time1); 
    return 0;
} 
