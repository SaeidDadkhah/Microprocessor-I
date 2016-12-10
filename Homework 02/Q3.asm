; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    
    STRING1 db 'abcde'
    STRING2 db 'abcde'
    NO_OF_BYTES dw 5
    
    ERROR_MSG DB 'ERROR$'
    OK_MSG DB 'OK$'
ends

stack segment
    dw   128  dup(0)
ends

code segment
start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    LEA SI, STRING1
    LEA DI, STRING2
    CLD
    MOV CX, NO_OF_BYTES
    REPE CMPSB
    JNZ ERROR
    JMP OK

    ERROR:
        LEA DX, ERROR_MSG
        JMP PRINT
    
    OK:
        LEA DX, OK_MSG
        
        
    PRINT:
    ;lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
ends

end start ; set entry point and stop the assembler.
