section .data
    msg db 'Enter a number: ', 0   ; Chuỗi thông báo

section .bss
    input resb 10                  ; Khoảng trống để lưu giá trị nhập vào

section .text
    global _start

_start:
    ; Xuất thông báo
    mov rax, 1                      ; Sử dụng syscall write (rax = 1)
    mov rdi, 1                      ; File descriptor stdout (rdi = 1)
    mov rsi, msg                    ; Địa chỉ chuỗi cần in ra màn hình
    mov rdx, 17                     ; Độ dài chuỗi
    syscall

    ; Nhập dữ liệu
    mov rax, 0                      ; Sử dụng syscall read (rax = 0)
    mov rdi, 0                      ; File descriptor stdin (rdi = 0)
    mov rsi, input                  ; Địa chỉ để lưu dữ liệu nhập vào
    mov rdx, 10                     ; Độ dài tối đa của dữ liệu nhập vào
    syscall

    ; Kết thúc chương trình
    mov rax, 60                     ; Sử dụng syscall exit (rax = 60)
    xor rdi, rdi                    ; Thoát với mã lỗi 0
    syscall
