; ---------- MACROS ----------

%macro print 2
mov  rax , 01  ; sys_write
mov  rdi , 01  ; stdout - file descriptor
mov  rsi , %1  ; address of string to print
mov  rdx , %2  ; no. of bytes to print
syscall
%endmacro

%macro read  2
mov  rax , 00  ; sys_read
mov  rdi , 00  ; stdin - file descriptor
mov  rsi , %1  ; address where bytes are to be stored
mov  rdx , %2  ; no. of bytes to read
syscall
%endmacro

%macro exit  0
mov  rax , 60   ; sys_exit
mov  rdx , 00   
syscall 
%endmacro

; ---------- DATA ----------

section .data
msg1  db  "Enter string: " , 0xA
len1  equ  $-msg1
newline db 0xA

; ---------- BSS ----------

section .bss
string resb  100   ; Allocate max. 100 bytes for the string
length resb  2     ; Length is printed in two bytes

; ---------- TEXT ----------

section .text
global _start
_start:

print msg1   , len1
read  string , 100

; length of input string is stored in al

dec  al                ; Decrement al to compensate for trailing null character
mov  bl  , al          ; Copy contents of al to bl
mov  rsi , length      ; mov 'length' base address to rsi

; Convert the length to ASCII characters
mov  dl, bl            ; Move the length to dl
add  dl, '0'           ; Convert to ASCII character
mov  [rsi]  ,  dl      ; Store the ASCII character in memory
inc  rsi               ; Move to the next memory location
mov  dl, 0            ; Null-terminate the string
mov  [rsi]  ,  dl      ; Store the null character

; Print the length
print length , 2      ; Print the 'ans' array upto 2 bytes

; Print newline
print newline, 1

exit
