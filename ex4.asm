;--------------------------------------------------------
; MACROS
%macro IO 4
    mov rax, %1  ; System call number
    mov rdi, %2  ; First argument
    mov rsi, %3  ; Second argument
    mov rdx, %4  ; Third argument
    syscall      ; Execute system call
%endmacro

;--------------------------------------------------------
; DATA SECTION
section .data
msg1 db "Enter choice (1. +, 2. -, 3. *, 4. /, 5. Exit): ", 0xA
len1 equ $-msg1
msg2 db "The 2 numbers are: ", 0xA
len2 equ $-msg2
n1 dq 15h      ; First number
n2 dq 5h        ; Second number
rem_msg db "Remainder is: ", 0xA
len_rem equ $-rem_msg
quo_msg db "Quotient is: ", 0xA
len_quo equ $-quo_msg
m_qou db "Quotient is "
m_qou_1 equ $-m_qou
m_rem db "Remainder is "
m_rem_1 equ $-m_rem

;--------------------------------------------------------
; BSS SECTION
section .bss
choice resb 2   ; Choice input buffer
ans resb 16     ; Answer buffer

;--------------------------------------------------------
; TEXT SECTION
section .text
global _start

_start:
    IO 1, 1, msg1, len1      ; Print "enter choice" message
    IO 0, 0, choice, 2       ; Read user input into the choice buffer

    cmp byte[choice], '4'     ; Compare choice with '4'
    JE divlbl
    cmp byte[choice], '3'     ; Compare choice with '3'
    JE mullbl
    cmp byte[choice], '2'     ; Compare choice with '2'
    JE sublbl
    cmp byte[choice], '1'     ; Compare choice with '1'
    JE addlbl

    ; Jump to respective labels based on choices
    sublbl:
        mov rax, [n1]             ; Move first number to rax
        mov rbx, [n2]             ; Move second number to rbx
        sub rax, rbx              ; Subtract second number from first
        call HtoA                  ; Convert result to ASCII
        JMP exit

    addlbl:
        mov rax, [n1]             ; Move first number to rax
        mov rbx, [n2]             ; Move second number to rbx
        add rax, rbx              ; Add first and second numbers
        call HtoA                  ; Convert result to ASCII
        JMP exit

    mullbl:
        xor rdx, rdx              ; Clear rdx (high bits)
        mov rax, [n1]             ; Move first number to rax
        mov rbx, [n2]             ; Move second number to rbx
        mul rbx                   ; Multiply first and second numbers (result in rdx:rax)
        push rax                   ; Save least significant bits (lower 32 bits)

        mov rax, rdx              ; Move most significant bits (higher 32 bits) to rax
        xor rdx, rdx              ; Clear rdx (high bits)
        call HtoA                  ; Convert most significant bits to ASCII

        pop rax                    ; Restore least significant bits
        call HtoA                  ; Convert least significant bits
        JMP exit

    divlbl:
        xor rdx, rdx              ; Clear rdx (high bits)
        mov rax, qword [n1]       ; Move first number to rax
        mov rbx, dword[n2]        ; Move second number to rbx
        div rbx                   ; Divide first number by second (quotient in rax, remainder in rdx)

        push rax                   ; Save quotient
        mov rax, rdx              ; Move remainder to rax
        IO 1, 1, rem_msg
