section .data
    msg db 'Enter a number: ', 0   ; Chuỗi thông báo
    buffer db 20                   ; Bộ nhớ đệm để lưu giá trị nhập vào
    len equ 20                     ; Độ dài tối đa của chuỗi nhập vào

section .text
    global _start

_start:
    ; Xuất thông báo
    mov eax, 4                      ; Gán mã syscall cho sys_write (eax = 4)
    mov ebx, 1                      ; File descriptor stdout (ebx = 1)
    mov ecx, msg                    ; Địa chỉ chuỗi cần in ra màn hình
    int 0x80                        ; Gọi syscall

    ; Nhập dữ liệu từ bàn phím
    mov eax, 3                      ; Gán mã syscall cho sys_read (eax = 3)
    mov ebx, 0                      ; File descriptor stdin (ebx = 0)
    mov ecx, buffer                 ; Địa chỉ bộ nhớ đệm để lưu dữ liệu nhập vào
    mov edx, len                    ; Độ dài tối đa của dữ liệu nhập vào
    int 0x80                        ; Gọi syscall

    ; Xuất dữ liệu nhập từ bàn phím ra màn hình
    mov eax, 4                      ; Gán mã syscall cho sys_write (eax = 4)
    mov ebx, 1                      ; File descriptor stdout (ebx = 1)
    mov ecx, buffer                 ; Địa chỉ bộ nhớ đệm chứa dữ liệu nhập vào
    int 0x80                        ; Gọi syscall

    ; Kết thúc chương trình
    mov eax, 1                      ; Gán mã syscall cho sys_exit (eax = 1)
    xor ebx, ebx                    ; Thoát với mã lỗi 0
    int 0x80                        ; Gọi syscall
