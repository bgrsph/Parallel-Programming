import matplotlib.pyplot as plt
from Debugger import *
from FileManager import *


class Plotter:
    def __init__(self,verbose):
        self.debugger = Debugger(verbose=verbose)
        self.fileManager = FileManager(verbose=verbose)

    def plot_num_rows_per_level(self, matrix_ID, dict, cumulative):
        if cumulative:
            self.debugger.debug("Plotting Cumulative Number of Rows per Level")
        else:
            self.debugger.debug("Plotting Number of Rows per Level")

        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()), cumulative=cumulative)
        plt.xlabel("Levels")
        plt.ylabel("Number of Rows")
        if cumulative:
            plt.title("Cumulative Number of Rows per Level")
            plt.savefig(self.fileManager.getMatrixFilePath(matrix_ID) + "/cumulative_num_rows_per_level")
        else:
            plt.title("Number of Rows per Level")
            plt.savefig(self.fileManager.getMatrixFilePath(matrix_ID) + "/num_rows_per_level")
        plt.clf()
        #plt.show()

    def plot_running_average_nnz_per_row(self, matrixID, dict):
        self.debugger.debug("Plotting Running Average for NNZ per Row ")
        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()))
        plt.title("Running Average for NNZ per Row")
        plt.xlabel("Rows")
        plt.ylabel("Average NNZ")
        plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/running_avg_nnz_per_row")
        plt.clf()
        #plt.show()

    def plot_running_average_nnz_per_column(self, matrixID, dict):
        self.debugger.debug("Plotting Running Average for NNZ per Column ")
        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()))
        plt.title("Running Average for NNZ per Column")
        plt.xlabel("Columns")
        plt.ylabel("Average NNZ")
        plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/running_avg_nnz_per_column")
        plt.clf()
        #plt.show()

    def plot_running_harmonic_average_nnz_per_row(self, matrixID, dict):
        self.debugger.debug("Plotting Running Harmonic Average for NNZ per Row ")
        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()))
        plt.title("Running Harmonic Average for NNZ per Row")
        plt.xlabel("Rows")
        plt.ylabel("Harmonic Average NNZ")
        plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/running_harmonic_avg_nnz_per_row")
        plt.clf()
        #plt.show()

    def plot_running_harmonic_average_nnz_per_column(self, matrixID, dict):
        self.debugger.debug("Plotting Running Harmonic Average for NNZ per Column ")
        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()))
        plt.title("Running Harmonic Average for NNZ per Column")
        plt.xlabel("Columns")
        plt.ylabel("Harmonic Average NNZ")
        plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/running_harmonic_avg_nnz_per_column")
        plt.clf()
        #plt.show()

    def plot_nnz_per_level(self,matrixID, dict, cumulative):
        if cumulative:
            self.debugger.debug("Plotting Cumulative NNZ per Level")
        else:
            self.debugger.debug("Plotting NNZ per Level")
        plt.hist(list(dict.keys()), weights=list(dict.values()),
                 bins=len(dict.values()), cumulative=cumulative)
        plt.xlabel("Level")
        plt.ylabel("NNZ")
        if cumulative:
            plt.title("Cumulative NNZ per Level")
            plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/cumulative_nnz_per_level")
        else:
            plt.title("NNZ per Level")
            plt.savefig(self.fileManager.getMatrixFilePath(matrixID) + "/nnz_per_level")

        plt.clf()
        #plt.show()