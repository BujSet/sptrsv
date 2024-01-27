#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <vector>

#include "MatrixLoader.hpp"

bool _compareByRow(const Entry_t *elem1, const Entry_t *elem2 ) {
    if (elem1->row == elem2->row) {
        return elem1->col < elem2->col;
    }
    return elem1->row < elem2->row;
}

MatrixLoader::MatrixLoader(std::string filePath, float zero_thresh) {
    std::ifstream input(filePath);
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
    int nentries  = std::stoi(token);
    this->nrows = nrows;
    this->ncols = ncols;
    this->nentries = nentries;
    int count = 0;
    int row, col;
    float val;
    std::vector<Entry_t*> v;
    // Start parsing the matrix
    while(getline(input, line)){
	    std::stringstream ss(line);
	    getline(ss, token, ' ');
	    row = std::stoi(token);
	    getline(ss, token, ' ');
	    col = std::stoi(token);
	    getline(ss, token, ' ');
	    val = std::stof(token);
	    if (std::abs(val) < zero_thresh) {
            continue;
	    }
	    Entry_t *ptr = new Entry_t;
	    ptr->row =row;
	    ptr->col = col;
	    ptr->val = val;
	    count++;
	    v.push_back(ptr);
    }
    this->nnz = count;
    std::sort(v.begin(), v.end(), &_compareByRow);
}

MatrixLoader::~MatrixLoader() {

}

void MatrixLoader::printConfigs() const {
    std::cout << "(" << nrows << "," << ncols << ")" << nnz <<std::endl;

}
