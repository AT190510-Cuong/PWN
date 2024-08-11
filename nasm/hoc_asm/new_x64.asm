section .data
    num1 dq 10          ; Khai báo biến num1 với giá trị là 10 (qword: 8 bytes)
    num2 dq 20          ; Khai báo biến num2 với giá trị là 20 (qword: 8 bytes)
    result dq 0         ; Biến result để lưu tổng, ban đầu được khởi tạo là 0 (qword: 8 bytes)

section .text
    global _start
_start:
    ; Load giá trị của num1 vào thanh ghi rax
    mov rax, [num1]
    ; Load giá trị của num2 vào thanh ghi rbx
    mov rbx, [num2]
    
    ; Tính tổng và lưu vào result
    add rax, rbx
    mov [result], rax

    ; Kết thúc chương trình
    mov rax, 60         ; Gán mã exit vào thanh ghi rax (60 là syscall cho exit)
    xor edi, edi        ; Đặt giá trị thoát là 0
    syscall             ; Gọi syscall để kết thúc chương trình
