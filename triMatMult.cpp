#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <istream>
using namespace std;

int main(int argc, char* argv[]){
    int input = 0, size = 0;
    vector <int> m1, m2, product2;
    for(int i = 1; i < argc; i++){
        ifstream file(argv[i]);
        file >> size;
        while(file >> input){
            if(i == 1) m1.push_back(input);
            if(i == 2) m2.push_back(input);
        }
    }
    
    int zeros = 0, mat1 = 0, mat2 = 0, col_zeros = 0;
    for(int row = 0; row < size; row++){
        for(int col = 0; col < size; col++){
            int sum = 0;
            int tmp1 = row + 1;
            zeros = tmp1*(tmp1-1) / 2;
            for(int k = 0; k < size; k++){
                if(k > col) continue;
                if(k < row) continue;
                mat1 = m1[size * row + k - zeros];
                int tmp = k + 1;
                col_zeros = tmp*(tmp-1) / 2;
                mat2 = m2[size * k + col - col_zeros];
                sum = sum  +  mat1 * mat2;
            }
            if(col >= row) product2.push_back(sum);
        }
    }
    for(vector<int>::iterator it = product2.begin(); it != product2.end(); it++){
        cout << *it << " ";
    }
    cout << endl;
}