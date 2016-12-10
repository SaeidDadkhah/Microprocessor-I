; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    
    MEMWDS DW 0500H
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
    MOV AL, 10
    
    MOV BL, AL
    MOV CL, 5
    MOV DX, 0
    ADD_START:
        CMP CL, BL
        JG ADD_END
        MOV AL, CL
        MUL CL
        ADD DX, AX
        ADD CL, 5
        JMP ADD_START
        
    
    ADD_END:
        MOV AX, DX

    lea dx, pkey
    mov ah, 9
    int 21h        ; output string at ds:dx
    
    ; wait for any key....    
    mov ah, 1
    int 21h
    
    mov ax, 4c00h ; exit to operating system.
    int 21h    
    ends

end start ; set entry point and stop the assembler.
