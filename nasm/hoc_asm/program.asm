section .data
    prompt db 'Enter a number: ', 0   ; Chuỗi thông báo
    format db '%d', 0                 ; Định dạng để in ra số nguyên
    newline db 0x0A, 0x0D, 0           ; Dấu xuống dòng

section .bss
    input resb 10                     ; Khoảng trống để lưu giá trị nhập vào

section .text
    global _start

    extern printf, scanf             ; Import các hàm printf và scanf từ thư viện C

_start:
    ; Hiển thị thông báo
    push prompt                      ; Push địa chỉ của chuỗi thông báo vào ngăn xếp
    call printf                      ; Gọi hàm printf
    add esp, 4                       ; Dọn ngăn xếp sau khi gọi hàm

    ; Nhập dữ liệu
    lea eax, [input]                 ; Load địa chỉ của input vào eax
    push eax                         ; Push địa chỉ của input vào ngăn xếp (đối số cho scanf)
    push format                      ; Push định dạng vào ngăn xếp (đối số cho scanf)
    call scanf                       ; Gọi hàm scanf
    add esp, 8                       ; Dọn ngăn xếp sau khi gọi hàm

    ; Xuất dữ liệu đã nhập ra màn hình
    push input                       ; Push giá trị của input vào ngăn xếp (đối số cho printf)
    push format                      ; Push định dạng vào ngăn xếp (đối số cho printf)
    call printf                      ; Gọi hàm printf
    add esp, 8                       ; Dọn ngăn xếp sau khi gọi hàm

    ; In dấu xuống dòng
    push newline                     ; Push dấu xuống dòng vào ngăn xếp
    call printf                      ; Gọi hàm printf
    add esp, 4                       ; Dọn ngăn xếp sau khi gọi hàm

    ; Kết thúc chương trình
    mov eax, 1                       ; Gán mã exit vào thanh ghi eax
    int 0x80                         ; Gọi syscall để kết thúc chương trình
