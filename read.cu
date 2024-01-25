
#include "mat.h"
#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>

int main()
{
    std::vector<double> v;
    matread("data.mat", v);
    for (size_t i=0; i<v.size(); ++i)
        std::cout << v[i] << std::endl;
    return 0;
}
