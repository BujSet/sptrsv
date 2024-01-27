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
    float val;
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

    std::vector<Entry_t> v;
    v.reserve(2*nnz); // Sparse matrix is symmetric



    for(getline( input, line );){
	std::stringstream ss(line);
	for (std::string token; getline(ss, token, ' ');) {
	    std::cout << token << std::endl;
	}
    }
    return 0;
}
