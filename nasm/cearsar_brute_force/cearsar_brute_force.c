#include <stdio.h>
#include <string.h>
#include <stdlib.h>

void encrypt (char plaintext[],char ciphertext[], int key)
{
    strcpy(ciphertext, plaintext);
    while(key<0)
    {
        key += 26;
    }
    for (int i=0; i<strlen(ciphertext); i++)
    {
        if (ciphertext[i] >= 'a' && ciphertext[i] <= 'z' )
        {
            //Tim STT
            ciphertext[i] -= 'a';

            //Dich di key don vi
            ciphertext[i] += key;
            ciphertext[i] %= 26;

            //Dua ve gia tri trong bang ma ascii
            ciphertext[i] += 'a';
        }
    }
}

void decrypt (char plaintext[],char ciphertext[], int key)
{
    strcpy(ciphertext, plaintext);
    while(key<0)
    {
        key += 26;
    }
    for (int i=0; i<strlen(ciphertext); i++)
    {
        if (ciphertext[i] >= 'a' && ciphertext[i] <= 'z' )
        {
            //Tim STT
            ciphertext[i] -= 'a';

            //Dich di key don vi
            ciphertext[i] -= key;
            ciphertext[i] %= 26;

            //Dua ve gia tri trong bang ma ascii
            ciphertext[i] += 'a';
        }
    }
}

int main()
{
    char plaintext[100];
    char ciphertext[100];
    int key = 5;
    strcpy(plaintext, "hoc tap tot lao dong tot");
    encrypt(plaintext, ciphertext, key);
    puts(ciphertext);
    for (int i=1; i<=26 ; i++)
    {
        decrypt(ciphertext, plaintext, i);
        printf("Key = %2d,  ciphertext: %30s\n",i, plaintext);
    }
    return 0;
}

