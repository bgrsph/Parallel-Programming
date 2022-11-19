from MatrixDownloader import *
from MatrixAnalyzer import *
from Plotter import *
from FileManager import *
import argparse


# Parse the command line arguments
parser = argparse.ArgumentParser(description='Analyzes a matrix with given ID and produces histograms')
parser.add_argument('matrix_ID', type=int, help='ID of the matrix file')
args = parser.parse_args()

# Assign the argument to a global variable
MATRIX_ID = args.matrix_ID

# Make it True to see the progress
verbose = False

# Initialize classes
matrix_downloader = MatrixDownloader(verbose=verbose)
matrix_analyzer = MatrixAnalyzer(verbose=verbose)
plotter = Plotter(verbose=verbose)
fileManager = FileManager(verbose=verbose)

# Create an empty directory to store the results
fileManager.createDirForResults(path="results")

# Download the matrix
CSR_Matrix_Lower_Triangular = matrix_downloader.getCSRMatrix(matrix_id=MATRIX_ID, diagonal="lower")

# Create matrix directories for results if the download is successful
fileManager.createDirForMatrix(matrixID=MATRIX_ID)

# Extract the features
level_sets = matrix_analyzer.getLevels(csr_matrix=CSR_Matrix_Lower_Triangular)
nnz_per_row = matrix_analyzer.get_nnz_per_row(csr_matrix=CSR_Matrix_Lower_Triangular,action="raw")
nnz_per_column = matrix_analyzer.get_nnz_per_column(csr_matrix=CSR_Matrix_Lower_Triangular,action="raw")

# TODO 1: histogram of nnz per level
nnz_per_level = matrix_analyzer.get_nnz_per_level(level_sets=level_sets, matrix=CSR_Matrix_Lower_Triangular)
plotter.plot_nnz_per_level(matrixID=MATRIX_ID,dict=nnz_per_level,cumulative=False)


# TODO 2: histogram of cumulative nnz per level
plotter.plot_nnz_per_level(matrixID=MATRIX_ID,dict=nnz_per_level,cumulative=True)


# TODO 3: histogram of  number of rows per level
num_rows_per_level = matrix_analyzer.get_num_of_rows_per_level(level_set=level_sets)
plotter.plot_num_rows_per_level(matrix_ID=MATRIX_ID, dict=num_rows_per_level,cumulative=False)

# TODO 4: histogram of number of columns per level


# TODO 5: histogram of cumulative number of rows per level
plotter.plot_num_rows_per_level(matrix_ID=MATRIX_ID, dict=num_rows_per_level,cumulative=True)

# TODO 6: histogram of cumulative number of columns per level


# TODO 7: histogram of running mean of nnz per row
running_avg_nnz_per_row = matrix_analyzer.get_running_average_nnz_per_row(nnz_per_row=nnz_per_row)
plotter.plot_running_average_nnz_per_row(matrixID=MATRIX_ID, dict=running_avg_nnz_per_row)

# TODO 8: histogram of running mean of nnz per column
running_avg_nnz_per_column = matrix_analyzer.get_running_average_nnz_per_column(nnz_per_column=nnz_per_column)
plotter.plot_running_average_nnz_per_column(matrixID=MATRIX_ID, dict=running_avg_nnz_per_column)

# TODO 9: histogram of running harmonic mean of nnz per row
running_harmonic_average_nnz_per_row = matrix_analyzer.get_running_harmonic_average_nnz_per_row(nnz_per_row=nnz_per_row)
plotter.plot_running_harmonic_average_nnz_per_row(matrixID=MATRIX_ID, dict=running_harmonic_average_nnz_per_row)

# TODO 10: histogram of running harmonic mean of nnz per column
running_harmonic_average_nnz_per_column = matrix_analyzer.get_running_harmonic_average_nnz_per_column(nnz_per_column=nnz_per_column)
plotter.plot_running_harmonic_average_nnz_per_column(matrixID=MATRIX_ID, dict=running_harmonic_average_nnz_per_column)


# TODO: fix ssget error if Najeeb encounters since it depends on the OS max_file_size