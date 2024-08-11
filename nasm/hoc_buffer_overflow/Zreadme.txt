gcc -g -m32 flag.c -o flag.out -fno-stack-protector  -z execstack -mpreferred-stack-boundary=2 

thêm option: -mpreferred-stack-boundary=2 (dễ đọc hơn)
             -m32 (32 bít)
             -fno-stack-protector (tắt phát hiện ghi đè trên stack)

Stack không thể thực thi (NX Stack): Điều này ngăn chặn việc thực thi mã từ vùng nhớ stack. Để tắt NX Stack, bạn có thể sử dụng -z execstack.

đặt break:  break *0x565555b1

step 
 break *0x56555661

 run $(python -c "print('a'*9 + 'b')")

 x/32xb &esp


  ./pattern.out  $(python -c "print(8*'a' + '\x62\x42\x61\x41')")    
  tương đương : ./pattern.out  $(python -c "print(8*'a' + 'bBax')") 

Tắt PIE (Position Independent Executable):
Tùy chọn -no-pie trong GCC tắt PIE.

Tắt RELRO (RELocation Read-Only):
RELRO có thể được tắt bằng cách sử dụng -z norelro hoặc -z now trong GCC.

Tắt NX (No eXecute):
NX thường được kích hoạt bởi hệ điều hành để ngăn chặn việc thực thi mã trên stack hoặc các vùng nhớ không thể thực thi. Trong GCC, không có tùy chọn trực tiếp để tắt NX.

Tắt FORTIFY:
Tùy chọn -U_FORTIFY_SOURCE có thể tắt FORTIFY trong GCC.

Tắt CANARY:
Tùy chọn -fno-stack-protector trong GCC tắt CANARY (canary value) - giá trị canary được sử dụng để phát hiện buffer overflow.

gcc -g -m32 ctf.c -o ctf.out -no-pie -z norelro -U_FORTIFY_SOURCE -fno-stack-protector

 gcc -g -m32 ctf.c -o ctf.out -no-pie -U_FORTIFY_SOURCE -fno-stack-protector -z norelro -z execstack  -mpreferred-stack-boundary=2 

gcc -fno-stack-protector vuln.c -o vuln -z execstack -D_FORTIFY_SOURCE=0 (tắt nx, canary, fortify)
echo 0 | sudo tee /proc/sys/kernel/randomize_va_space (tắt pie)
đây nhé b