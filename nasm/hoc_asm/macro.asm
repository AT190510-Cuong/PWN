%macro writeStr 2
    mov edx, %2
    mov ecx, %1
    mov ebx, 1
    mov eax, 4
    int 0x80
%endmacro

%macro encrypt 3
    mov esi, %1
    mov ecx, %2-1
    %%loop_label:
    xor byte[esi], %3
    inc esi
    loop %%loop_label
%endmacro

section .data
SYS_EXIT equ 1
EXIT_SUCCESS equ 0    
msg db 'Assembly programming',10
mlen equ $-msg
KEY equ 0x88
section .text
global _start
_start:
    encrypt msg,mlen,KEY
    writeStr msg,mlen
    encrypt msg,mlen,KEY
    writeStr msg,mlen
last:
    mov eax, SYS_EXIT
    mov ebx, EXIT_SUCCESS
    int 0x80



