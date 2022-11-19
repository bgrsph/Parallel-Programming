import os
from Debugger import *

class FileManager:
    def __init__(self, verbose):
        self.debugger = Debugger(verbose=verbose)

    def createDirForResults(self,path):
        if not os.path.exists(path):
            os.mkdir(path)

    def getMatrixFilePath(self,matrixID):
        return "results/" + str(matrixID)

    def createDirForMatrix(self,matrixID):
        if not os.path.exists("results/" + str(matrixID)):
            os.mkdir("results/" + str(matrixID))