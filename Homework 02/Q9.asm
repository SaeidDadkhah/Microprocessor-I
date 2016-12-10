; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
ends

stack segment
    dw   128  dup(0)
ends

code segment

PUSHER_LABEL:
    PUSHER_PROC PROC NEAR
        MOV DX, 0B000H
        IN AL, DX
        MOV AX, 00010H
        ;MOV AX, 0EEEEH
        TEST AL, 10H
        JZ PUSHER_END
        
        POP BX
        ;POP CX
        PUSH AX
        ;PUSH CX
        PUSH BX
        
        PUSHER_END:
            RET

start:
; set segment registers:
    mov ax, data
    mov ds, ax
    mov es, ax

    ; add your code here
    PUSH 0FFEFH
    CALL PUSHER_PROC
    POP AX
    
            
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
