#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>

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
	    this->v.push_back(ptr);
    }
    this->nnz = count;
    std::sort(this->v.begin(), this->v.end(), &_compareByRow);
    input.clear();
    input.seekg(0);
}

MatrixLoader::~MatrixLoader() {
    for (Entry_t *ptr : this->v) {
        delete ptr;
    }
}

void MatrixLoader::printConfigs() const {
    std::cout << "Matrix: (" << nrows << "," << ncols << ") with " << nnz << " non zero entries" << std::endl;

}
