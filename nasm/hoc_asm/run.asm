session .bss
    num1 resb 2
    num2 resb 2
    result resb 2

section .text
    global _start

_start:
    mov eax, 3
    mov ebx, 0
    mov ecx, num1
    mov edx, 2
