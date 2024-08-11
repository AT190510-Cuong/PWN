section .data
    msg db "Enter x,y:",0
    format db "%d %d",0
    pStr times 25 db 0
section .bss
    x resd 1
    y resd 1
section .text
    extern printf
    extern scanf
    global _start
_start:
    push msg
    call printf
    add esp, 4
    push y
    push x
    push format
    call scanf
    add esp, 12
_last:
    mov eax, 1
    int 0x80