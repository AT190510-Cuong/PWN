Biên dịch ra file Object code:
    c1: nasm -g -f elf first.asm (-l f.lst) với x86: 32bit 
      : nasm -g -f elf64 first.asm  với x64: 64 bit

    c2: nasm -g  -f elf program.asm -o program.o 

Link thư viện để chạy trong assembly:
    ld -m elf_i386 -o first first.o 

Link thư viện để chạy trong C:
    ld -m elf_i386 -o first first.o -lc -I /lib/ld-linux.so.2 với x86
    ld -m elf_x86_64 -o x64 x64.o -lc -I /lib/ld-linux.so.2  với x64

Option -lc: sẽ liên kết với thư viện C chuẩn (C runtime library), cần thiết khi sử dụng các hàm của thư viện C như printf và scanf.

Option -I /lib/ld-linux.so.2 chỉ định đường dẫn của dynamic linker (ld-linux.so.2), thường không cần thiết trong trường hợp liên kết.

Supported emulations: 
    elf_x86_64 elf32_x86_64 elf_i386 elf_iamcu i386linux elf_l1om elf_k1om i386pep i386pe

