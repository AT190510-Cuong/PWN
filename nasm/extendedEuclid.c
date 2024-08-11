#include <stdio.h>

void extendedEuclid(int a, int b, int* gcd, int* x, int* y) {
    // Trường hợp cơ sở
    if (b == 0) {
        *gcd = a;
        *x = 1;
        *y = 0;
    }
    else {
        int x1, y1;
        extendedEuclid(b, a % b, gcd, &x1, &y1);
        *x = y1;
        *y = x1 - (a / b) * y1;
    }
}

int main() {
    int a, b, gcd, x, y;

    printf("Nhập số a: ");
    scanf("%d", &a);
    printf("Nhập số b: ");
    scanf("%d", &b);

    extendedEuclid(a, b, &gcd, &x, &y);

    printf("Ước số chung lớn nhất (GCD) của %d và %d là %d\n", a, b, gcd);
    printf("Các hệ số Bézout x và y là %d và %d\n", x, y);

    return 0;
}

