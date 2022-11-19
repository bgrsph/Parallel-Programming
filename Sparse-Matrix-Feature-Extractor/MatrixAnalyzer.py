from Debugger import *
import numpy as np


class MatrixAnalyzer:
    def __init__(self, verbose):
        self.debugger = Debugger(verbose)

    def getLevels(self, csr_matrix):
        self.debugger.debug("Calculating Matrix Levels...")
        level_sets = {}
        num_rows = csr_matrix.get_shape()[0]
        num_columns = csr_matrix.get_shape()[1]
        for i in range(1, num_rows+1):
            level_sets[i] = 0
    
        # level_sets[i] = the level of i'th unknown
        for i in range(1, num_rows+1):
            self.debugger.debug("Analyzing Row " + str(i) + "... Remaining: " + str(num_rows + 1 - i))
            local_max = float('-inf')
            for j in range(1, num_columns+1):
                if csr_matrix[i-1, j-1] != 0:
                    if level_sets[j] > local_max:
                        local_max = level_sets[j]
            if local_max == float('-inf'):
                continue
            else:
                level_sets[i] = 1 + local_max
        self.debugger.debug("Matrix Levels Calculated")
        return level_sets

    def getLevels_colwise(self, csr_matrix):
        self.debugger.debug("Calculating Matrix Levels...")
        level_sets = {}
        num_rows = csr_matrix.get_shape()[0]
        num_columns = csr_matrix.get_shape()[1]
        for i in range(0, num_rows):
            level_sets[i] = 0

        # level_sets[i] = the level of i'th unknown
        for j in range(0, num_columns):
            local_max = level_sets[j] + 1
            for i in range(0, num_rows):
                if csr_matrix[i, j] != 0:
                    level_sets[i] = max(local_max, level_sets[i])

            # It means matrix either cannot be read or it's empty somehow
            if local_max == float('-inf'):
                self.debugger.rise_Error("Rows or Columns cannot be read during Level Calculation")
                exit(1)
        self.debugger.debug("Matrix Levels Calculated")
        return level_sets

    def get_nnz_per_row(self, csr_matrix, action="raw"):
        """
        Parameters:
            csr_matrix (scipy.csr): the sparse matrix in CSR format
            action=avg (String): average number of non-zeros per row
            action=max (String): maximum number of non-zeros per row
            action=std (String): standard deviation of non-zeros per row
            action=raw (String): the dictionary that has the format: {row_index, number of non-zero elements}

        Returns:
            dictionary or float: statistics about number of non zeros elements in the columns of the matrix

        """
        nnz_per_row = {}
        num_rows = csr_matrix.get_shape()[0]
        for row_id in range(1, num_rows+1):
            nnz_per_row[row_id] = csr_matrix.getrow(row_id-1).getnnz()
        if action == "avg":
            return np.array(list(nnz_per_row.values())).mean()
        if action == "max":
            return np.array(list(nnz_per_row.values())).max()
        if action == "std":
            return np.array(list(nnz_per_row.values())).std()
        if action == "raw":
            return nnz_per_row
        else:
            self.debugger.rise_Error("Unknown action for get_nnz_per_row: " + str(action))
            exit(1)

    def get_nnz_per_column(self, csr_matrix, action="raw"):
        """
         Parameters:
            csr_matrix (scipy.csr): the sparse matrix in CSR format
            action=avg (String): average number of non-zeros per column
            action=max (String): maximum number of non-zeros per column
            action=std (String): standard deviation of non-zeros per column
            action=raw (String): the dictionary that has the format: {column_index, number of non-zero elements}

         Returns:
            dictionary or float: statistics about number of non zeros elements in the columns of the matrix

         """
        nnz_per_column = {}
        num_columns = csr_matrix.get_shape()[1]
        for column_id in range(1, num_columns+1):
            nnz_per_column[column_id] = csr_matrix.getcol(column_id-1).getnnz()
        if action == "avg":
            return np.array(list(nnz_per_column.values())).mean()
        if action == "max":
            return np.array(list(nnz_per_column.values())).max()
        if action == "std":
            return np.array(list(nnz_per_column.values())).std()
        if action == "raw":
            return nnz_per_column
        else:
            self.debugger.rise_Error("Unknown action for get_nnz_per_column: " + str(action))
            exit(1)


    def get_num_of_rows_per_level(self, level_set):
        rows_per_level = {n: [k for k in level_set.keys() if level_set[k] == n] for n in set(level_set.values())}
        num_rows_per_level = {}
        for level,rows in rows_per_level.items():
            num_rows_per_level[level] = len(rows)
        return num_rows_per_level

    def get_running_average_nnz_per_row(self,nnz_per_row):
        cumulative_sum = 0
        running_avg_nnz_per_row = {}
        for row, nnz in nnz_per_row.items():
            cumulative_sum += nnz
            local_avg = cumulative_sum / nnz
            running_avg_nnz_per_row[row] = local_avg
        return running_avg_nnz_per_row

    def get_running_average_nnz_per_column(self,nnz_per_column):
        cumulative_sum = 0
        running_avg_nnz_per_column = {}
        for col, nnz in nnz_per_column.items():
            cumulative_sum += nnz
            local_avg = cumulative_sum / nnz
            running_avg_nnz_per_column[col] = local_avg
        return running_avg_nnz_per_column


    def get_running_harmonic_average_nnz_per_row(self,nnz_per_row):
        cumulative_sum = 0
        running_harmonic_avg_nnz_per_row = {}
        for row, nnz in nnz_per_row.items():
            cumulative_sum += 1 / nnz
            local_avg = nnz / cumulative_sum
            running_harmonic_avg_nnz_per_row[row] = local_avg
        return running_harmonic_avg_nnz_per_row

    def get_running_harmonic_average_nnz_per_column(self,nnz_per_column):
        cumulative_sum = 0
        running_harmonic_avg_nnz_per_column = {}
        for col, nnz in nnz_per_column.items():
            cumulative_sum += 1 / nnz
            local_avg = nnz / cumulative_sum
            running_harmonic_avg_nnz_per_column[col] = local_avg
        return running_harmonic_avg_nnz_per_column

    def get_nnz_per_level(self,level_sets, matrix):
        nnz_per_level = {}
        rows_per_level = {n: [k for k in level_sets.keys() if level_sets[k] == n] for n in set(level_sets.values())}
        for (level, rows) in rows_per_level.items():
            nnz = 0
            for row in rows:
                nnz += matrix.getrow(row-1).nnz
            nnz_per_level[level] = nnz
        return nnz_per_level
