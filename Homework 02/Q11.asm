; multi-segment executable file template.

data segment
    ; add your data here!
    pkey db "press any key...$"
    
    LEN DB 5
    ARR DB 1, 5, 2, 4, 3
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
    MAIN_LOOP:
        MOV CX, 1
        LEA SI, ARR
        FOR_LOOP_START:
            ; for loop condition check
            CMP CL, LEN
            JGE FOR_LOOP_END
            INC CL
            
            ; for loop body
            MOV DL, BYTE PTR[SI]
            INC SI
            CMP DL, BYTE PTR[SI]
            JG FOR_LOOP_START
            INC CH
            MOV DH, BYTE PTR[SI]
            MOV BYTE PTR[SI-1], DH
            MOV BYTE PTR[SI], DL
            JMP FOR_LOOP_START
            
        FOR_LOOP_END:
        
        CMP CH, 0
        JNZ MAIN_LOOP

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
