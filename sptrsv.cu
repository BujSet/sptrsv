#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <hipsparse/hipsparse.h>

typedef struct {
    int row;
    int col;
    int val;
} Entry_t;

int main(){
    std::ifstream input("mawi_201512020330/mawi_201512020330.mtx");
    std::string line;
    // Get the first line
    getline(input, line);
    std::cout << line << std::endl;
    std::stringstream stream(line);
    std::string token;

    getline(stream, token, ' ');
    int nrows = std::stoi(token);
    getline(stream, token, ' ');
    int ncols = std::stoi(token);
    getline(stream, token, ' ');
    int nnz  = std::stoi(token);

    std::cout << "(" << nrows << "," << ncols << ")" << nnz <<std::endl;

    std::vector<Entry_t*> v;
    v.reserve(2*nnz); // Sparse matrix is symmetric

    int row, col;
    int val;
//    int count = 0;

    // Start parsing the matrix
//    while(getline( input, line )){
//	std::stringstream ss(line);
//	getline(ss, token, ' ');
//	row = std::stoi(token);
//	getline(ss, token, ' ');
//	col = std::stoi(token);
//	getline(ss, token, ' ');
//	val = std::stoi(token);
//	Entry_t *ptr = new Entry_t;
//	ptr->row =row;
//	ptr->col = col;
//	ptr->val = val;
//	count++;
//	v.push_back(ptr);
//	if (row != col) {
//	    // also need to add in the transpose
//	    Entry_t *transpose = new Entry_t;
//	    transpose->row = col;
//	    transpose->col = row;
//	    transpose->val = val;
//	    v.push_back(transpose);
//	    count++;
//	}
//
//    }
//    std::cout << "Found " << count << " nnz entries" << std::endl; 
    hipsparseHandle_t handle;
    hipsparseStatus_t stat;
    std::cout << "Creating handle" << std::endl; 
    stat = hipsparseCreate(&handle);
    assert(stat == HIPSPARSE_STATUS_SUCCESS);

    stat = hipsparseDestroy(&handle);
    assert(stat == HIPSPARSE_STATUS_SUCCESS);
    return 0;
}
