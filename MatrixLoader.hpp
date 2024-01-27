#include <string>

#ifndef __MATRIX_LOADER_HPP__
#define __MATRIX_LOADER_HPP__

typedef struct {
    int row;
    int col;
    float val;
} Entry_t;

class MatrixLoader {
private:
    // Number of rows in the matrix
    int nrows;
    // Number of cols in the matrix
    int ncols;
    // Number of entries in the matrix (some may be zero)
    int nentries;
    // Number of non-zero entries in the matrix
    int nnz;

public:
    MatrixLoader(std::string filePath, float zero_thresh);
    ~MatrixLoader();

    void printConfigs() const;

};


#endif // __MATRIX_LOADER_HPP__
