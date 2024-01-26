#include <iostream>
#include <vector>
#include <iostream>
#include <fstream>
#include <string>

int main()
{
    std::vector<double> v;
    MATFile * mf = matOpen("data.mat", "r");
    std::cout << "Hello world" << std::endl;
    matClose(mf);
    return 0;
}
