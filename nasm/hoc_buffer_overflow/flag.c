#include<stdio.h>
#include<string.h>

int main(int argc, char* argv[]){
    int flag=0;
    char buffer[8];

    strcpy(buffer, argv[1]);
    printf(argv[0]);
    printf("\n");
    printf(argv[1]);
    printf("\n");
    printf(argv[2]);
    printf("\n");
    printf("so bien: %d", argc);
    printf("\n");
    printf("flag: %d", flag);
    printf("\n");
    
    if(flag != 0)
        printf("Modified!\n");
    else
        printf("try again\n");
    return 0;
}