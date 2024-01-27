#include <algorithm>
#include <iostream>
#include <fstream>
#include <sstream>
#include <stdio.h>
#include <vector>

#include "MatrixLoader.hpp"

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
    this.nrows = nrows;
    this.ncols = ncols;
    this.nentries = nentries;
    int count = 0;
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
    this.nnz = count;
    std::sort(v.begin(), v.end(), &compareByRow);

    std::cout << "(" << nrows << "," << ncols << ")" << nnz <<std::endl;


}

MatrixLoader::~MatrixLoader() {

}
MatrixLoader::printConfigs() const {

}
