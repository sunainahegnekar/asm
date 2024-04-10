; MACROS
%macro IO 4
    mov rax, %1   ; System call number
    mov rdi, %2   ; Argument for system calls
    mov rsi, %3
    mov rdx, %4
    syscall
%endmacro

%macro convert 2  ; Macro for Hex to ASCII Conversion
    cmp byte[%1], 9
    jbe .next%2
    add byte[%1], 7   ; Adjust for non-digit characters
.next%2:
    add byte[%1], 30h  ; Convert to ASCII character
%endmacro

; DATA SECTION
section .data
    array: dq -64, -38, 66, 89, -90, 70, 33, -50, 29, 111
    pos: db 0   ; Count of positive numbers
    neg: db 0   ; Count of negative numbers
    count: db 10 ; Number of elements in the array
    msg1: db 'Positive numbers: '
    len1: equ $ - msg1
    msg2: db 10, 'Negative numbers: '
    len2: equ $ - msg2

; TEXT SECTION
section .text
    global start

start:
    mov rsi, array  ; Load the starting address of array into rsi

up:
    mov rax, qword[rsi]  ; Load current element into rax
    cmp rax, 0       ; Compare with zero to check for sign
    jge positive     ; Jump to positive if non-negative

negative:
    inc byte[neg]    ; Increment negative counter
    add rsi, 8       ; Move to the next element
    dec byte[count]  ; Decrement the loop counter
    jnz up           ; Jump back to up if not zero
    jmp HtoA         ; Otherwise, jump to conversion

positive:
    inc byte[pos]    ; Increment positive counter
    add rsi, 8       ; Move to the next element
    dec byte[count]  ; Decrement the loop counter
    jnz up           ; Jump back to up if not zero

HtoA:
    convert pos, 2   ; Convert positive counter to ASCII
    convert neg, 3   ; Convert negative counter to ASCII

    ; Print results
    IO 1, 1, msg1, len1
    IO 1, 1, pos, 1
    IO 1, 1, msg2, len2
    IO 1, 1, neg, 1

    ; Exit
    mov rax, 60      ; System call for exit
    mov rdi, 1       ; Exit status
    syscall
