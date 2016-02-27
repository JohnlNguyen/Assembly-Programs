#include <iostream>
#include <string>
#include <cmath>
#include <stack>
using namespace std;

string tobase(int base10num, int newbase){
    stack<int> s;
    string st = "\0";
    int quotient = base10num / newbase;
    int r =  base10num % newbase;
    s.push(r);
    while(quotient != 0){
        r = quotient % newbase;
        
        s.push(r);
        
        quotient = quotient / newbase;
        
    }
    while(!s.empty()){
        string str = to_string(s.top());
        if(str.length() > 1){
            char c = stoi(str)+ 55;
            st += c;
        }
        else st += str;
        s.pop();
    }
    return st;
}

int main()
{
    string number;
    int base;
    int output;
    cout << "Please enter the number's base: ";
    cin >> base;
    cout << "Please enter the number: ";
    cin >> number;
    cout << "Please enter the new base: ";
    cin >> output;
    int finalTotal = 0;
    for(int i = 0; i < number.length(); i++)
    {
        int digit = 0;
        if(isdigit(number[i]))
        {
            digit = number[i]-48;
            
        }
        if(isalpha(number[i]))
        {
            digit = number[i]-55;
        }
        finalTotal += digit*pow(base,number.length()-i-1);
    }
    cout << number << " base " << base << " is " << tobase(finalTotal, output)
    << " base " << output;
    cout << endl;
}
