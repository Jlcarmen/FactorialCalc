; Data segment
section .data
    msg1 db "Enter a non-negative integer: ", 0
    msg1_len equ $ - msg1  ; Calculate the length of msg1
    msg2 db "Factorial: ", 0
    msg2_len equ $ - msg2  ; Calculate the length of msg2
    newline db 10, 0 ; newline.
    newline_len equ $ - newline  ; Calculate the length of newline.
    prompt db "Do you want to enter another number? (y/n): ", 0
    prompt_len equ $ - prompt  ; Length of the prompt message
    exit_msg db "Exiting program...", 0
    exit_msg_len equ $ - exit_msg ; Length of exit message

; BSS segment (uninitialized data)
section .bss
    input resb 10
    result resb 50
    user_choice resb 1

; Text segment (code)
section .text
    global _start

_start:
ask_for_input:
    ; Display "Enter a non-negative integer"
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, msg1
    mov edx, msg1_len
    int 0x80

    ; Read input
    mov eax, 3      ; sys_read
    mov ebx, 0      ; stdin
    mov ecx, input
    mov edx, 10
    int 0x80

    ; Convert input string to number (handle multiple digits)
    xor eax, eax    ; Clear eax (result)
    xor ebx, ebx    ; Clear ebx (multiplier for power of 10)
    mov ecx, input  ; Pointer to input string

convert_loop:
    movzx edx, byte [ecx]  ; Load next character
    cmp dl, 10              ; Check for newline (end of input)
    je done_converting      ; If newline, done converting
    sub dl, '0'             ; Convert ASCII to integer
    imul eax, eax, 10       ; Multiply current result by 10
    add eax, edx            ; Add the new digit to the result
    inc ecx                 ; Move to the next character
    jmp convert_loop

done_converting:
    ; Store the number in bl for factorial calculation
    mov ebx, eax            ; Store the number to calculate factorial

    ; Calculate factorial (iterative)
    mov eax, 1              ; Initialize result to 1
    cmp ebx, 0
    je print_result         ; 0! = 1
    cmp ebx, 1
    je print_result         ; 1! = 1

factorial_loop:
    ; Multiply eax by ebx (accumulate result)
    imul eax, ebx
    dec ebx                  ; Decrement ebx
    cmp ebx, 1
    jge factorial_loop

print_result:
    ; Convert the result EAX to a string.
    mov ecx, result
    mov esi, 0              ; Used as index for the string.

convert_result_loop:
    xor edx, edx            ; Clear edx.
    mov ebx, 10
    div ebx                 ; eax = eax / 10, edx = eax % 10
    add dl, '0'             ; Convert remainder to ASCII
    mov [ecx + esi], dl     ; Store ASCII char in result string.
    inc esi                 ; Increase index.
    cmp eax, 0              ; Check if quotient is 0.
    jne convert_result_loop

reverse_string:  ; Reverse the string for correct output.
    mov edi, esi
    dec edi                 ; edi now points to the last char.
    mov ebx, 0              ; ebx will point to the first char.

reverse_loop:
    cmp ebx, edi            ; Check if we have reached the middle.
    jge print_final_result  ; If so, print.
    mov al, [ecx + ebx]     ; Get first char.
    mov dl, [ecx + edi]     ; Get last char.
    mov [ecx + ebx], dl     ; Swap the chars.
    mov [ecx + edi], al     ; Swap the chars.
    inc ebx                 ; Increase first index.
    dec edi                 ; Decrease last index.
    jmp reverse_loop        ; Loop again.

print_final_result:
    ; Display "Factorial: "
    mov eax, 4
    mov ebx, 1
    mov ecx, msg2
    mov edx, msg2_len
    int 0x80

    ; Display result
    mov eax, 4
    mov ebx, 1
    mov ecx, result
    mov edx, esi ; Length of string.
    int 0x80

    ; Display newline.
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, newline_len
    int 0x80

    ; Prompt for another number or exit
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; Read user choice (y/n)
    mov eax, 3      ; sys_read
    mov ebx, 0      ; stdin
    mov ecx, user_choice
    mov edx, 1      ; Read 1 byte (the choice)
    int 0x80

    ; Check if user wants to continue (y) or exit (n)
    cmp byte [user_choice], 'y'
    je ask_for_input ; If 'y', ask for another number
    cmp byte [user_choice], 'n'
    je exit_program  ; If 'n', exit the program

    ; If user input is invalid, prompt again
    jmp print_result

exit_program:
    ; Display exit message
    mov eax, 4      ; sys_write
    mov ebx, 1      ; stdout
    mov ecx, exit_msg
    mov edx, exit_msg_len
    int 0x80

    ; Exit the program
    mov eax, 1      ; sys_exit
    xor ebx, ebx    ; Exit code 0
    int 0x80
