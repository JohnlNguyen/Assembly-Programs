#include <iostream>
#include <vector>
#include <math.h>
#include <algorithm>
using namespace std;

union Binary{
    float f;
    int integer;
};

//Zeros checker function
bool check(vector<int> vect, int counter){
    for(vector<int>::iterator i = vect.begin() + counter; i != vect.end(); i++){
        if(*i == 1) return true;
    }
    return false;
}
int main(){
    
    Binary b;
    vector<int> v, s;
    cout << "Please enter a float: ";
    cin >> b.f;
    int exponent = 0;
    for(int i=31;i>=0;i--){           //Converting to binary 
        if((b.integer & (1 << i))){
            v.push_back(1);
            if(i == 31) cout << "-";
        }
        if(!(b.integer & (1 << i)))
            v.push_back(0);
    }
    
    if(check(v,0)) cout << "1.";        //Check for 0 as input
    else{
        cout << "0E0" << endl;
        return 0;
    }
    
    for(int i = 9; i < 32; i++)       //Print mantissa
        if(check(v,i)) cout << v[i];
    
    reverse(v.begin()+1,v.begin()+9);   //Getting the exponent
    for(int i = 1; i < 9; i++){
        if(v[i] == 1)
            exponent += pow(2,i-1);
    }
    exponent -= 127;
    cout << "E" << exponent;
    cout << endl;
}