#include<stdio.h>
#include<string.h>

int main(int argc, char* argv[]){
    int pattern;
    char buffer[8];

    strcpy(buffer, argv[1]);
    
    if(pattern == 0x41614262)
        printf("Correct!\n");
    else
        printf("Incorrect\n");
    return 0;
}