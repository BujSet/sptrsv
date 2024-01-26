#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>
#include <sstream>

int main(){
    std::ifstream input("mawi_201512020330/mawi_201512020330.mtx");
    for( std::string line; getline( input, line ); ){
	std::stringstream ss(line);
	for (std::string token; getline(ss, token, ' ');) {
	    std::cout << token << std::endl;
	}
    }
    return 0;
}
