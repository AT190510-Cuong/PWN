def ext_gcd(a,b):
    m, n = a, b
    xm, ym = 1, 0
    xn, yn = 0, 1
    while (n != 0):
        q = m // n # chia lấy phần nguyên
        r = m % n # chia lấy phần dư
        xr, yr = xm - q*xn, ym - q*yn
        m = n
        xm, ym = xn, yn
        n = r
        xn, yn = xr, yr
    return (m, xm, ym) # m = gcd(a,b) = xm * a + ym * b
a = int(input("hãy nhập số a: "))
b = int(input("hãy nhập số b: "))
print("=========================================================chúc Monstercuong7 một ngày tốt lành <3==============================")
print("(ước chung lớn nhất, x, y) lần lượt là: ",ext_gcd(a,b))

