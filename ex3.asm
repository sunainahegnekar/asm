;--------------------------------------------------------
; Section for data
section .data

msg: db "Largest Value: " ; Exit message
len equ $-msg ; Length of the exit message

array: db 23h, 07h, 34h, 50h, 0xF8 ; Array to be searched
cnt: db 04h ; Counter for array elements

;--------------------------------------------------------
; Section for uninitialized data
section .bss

ans resb 2 ; Variable to store the largest value in ASCII

;--------------------------------------------------------
; Section for code
section .text

global start ; Entry point for the program

start:
    mov r8, array  ; Store the starting address of array in R8
    mov al, byte[r8]  ; Load the first value of array into AL
    inc r8  ; Move to the next address in the array

compare:
    mov bl, byte[r8]  ; Load the current element of array into BL
    cmp bl, al  ; Compare AL and BL
    JA copyvalue  ; If BL is greater than AL, jump to copyvalue
    JMP nextstep  ; Otherwise, move to the next step

copyvalue:
    mov al, bl  ; Copy the value of BL into AL (the accumulator)

nextstep:
    inc r8      ; Increment the array pointer to the next element
    dec byte[cnt]  ; Decrement the counter
    JNZ compare  ; If counter is not zero, jump back to compare

;--------------------------------------------------------
; Convert the largest value to ASCII and print

mov rsi, ans  ; Move the address of ans into RSI
mov rcx, 02h  ; Set the counter to 2 (for two ASCII characters)

hextoascii:
    rol al, 04  ; Rotate AL to swap nibbles
    mov dl, al  ; Move AL into DL
    and dl, 0Fh  ; Mask out the lower nibble in DL
    cmp dl, 09h  ; Check if it's a digit (0-9)
    jbe copydigit  ; If it's a digit, jump to copydigit
    add dl, 07h  ; If it's a character (A-F), add 7 to convert to ASCII

copydigit:
    add dl, 30h  ; Add 30 to convert digit to ASCII
    mov [rsi], dl  ; Store the ASCII character in rsi
    inc rsi      ; Increment rsi to the next address
    dec rcx      ; Decrement the counter
    jnz hextoascii  ; If counter is not zero, jump back to hextoascii

;--------------------------------------------------------
; Print the exit message and the largest value

mov rax, 01      ; System call for write
mov rdi, 01      ; Standard output
mov rsi, msg     ; Message to print
mov rdx, len     ; Length of the message
syscall         ; Execute the system call

mov rax, 01      ; System call for write
mov rdi, 01      ; Standard output
mov rsi, ans     ; Larges value in ASCII
mov rdx, 03      ; Length of the value
syscall         ; Execute the system call

;--------------------------------------------------------
; Exit the program

mov rax, 60      ; System call for exit
mov rdi, 00      ; Exit status
syscall         ; Execute the system call
