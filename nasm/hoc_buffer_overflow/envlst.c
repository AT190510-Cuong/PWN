#include<stdio.h>
#include<string.h>
//extern char** environ;
void main(int argc, char* argv[], char* envp[]){
//    int i =0;
//    while (environ[i] != NULL)
//     printf("%s\n", environ[i++]);
     int i =0;
    while (envp[i] != NULL)
    printf("%s\n", envp[i++]);
   
}