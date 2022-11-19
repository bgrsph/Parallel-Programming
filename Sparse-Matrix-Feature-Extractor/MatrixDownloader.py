import subprocess
import scipy.io
from scipy.sparse import *
from Debugger import *
import urllib.request

class MatrixDownloader:
    def __init__(self, verbose):
        self.debugger = Debugger(verbose)
        try:
            urllib.request.urlopen('http://google.com')
        except:
            self.debugger.rise_Error("Internet Connection Cannot Be Established")
            exit(1)

    def getCSRMatrix(self, matrix_id, diagonal):
        self.debugger.debug("Downloading Matrix with ID: " + str(matrix_id))
        #MM_path = str(subprocess.run(['ssget', '-e', '-i', str(matrix_id)], stdout=subprocess.PIPE,
                   #                  stderr=subprocess.STDOUT)).split("'")[-2][:-2]
        result = subprocess.run(['ssget', '-e', '-i', str(matrix_id)], stdout=subprocess.PIPE)
        MM_path = result.stdout.decode().strip()
        self.debugger.debug("Matrix Path is " + str(MM_path))
        self.debugger.debug("Matrix Downloaded")
        Matrix_CSR = scipy.io.mmread(MM_path).tocsr()
        if diagonal == "lower":
            return tril(Matrix_CSR, k=0, format="csr")
        if diagonal == "upper":
            return triu(Matrix_CSR, k=0, format="csr")
        else:
            return Matrix_CSR