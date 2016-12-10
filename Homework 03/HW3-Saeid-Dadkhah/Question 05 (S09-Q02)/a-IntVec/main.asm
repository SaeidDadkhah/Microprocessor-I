;
; a-IntVec.asm
;
; Created: 11/24/2016 6:05:07 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
; start check BOOTRST
	; unprogram BOOTRST and uncomment next lines
		.org 0x00 jmp RST_ISR
	; program BOOTRST and uncomment next lines
		;.org 0x0000 jmp START
		;.org 0x1C00 jmp RST_ISR
; end check BOOTRST

RST_ISR:
	; init stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	jmp START

START:
	jmp START