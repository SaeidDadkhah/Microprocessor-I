;
; b-LED.asm
;
; Created: 11/20/2016 10:45:58 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
.org 0x00 jmp RST_ISR

RST_ISR:
	cli

	ldi r16, (1 << PD5)
	out ddrd, r16
	ldi r16, (1 << PD3)
	out portd, r16
	
	sei

START:
	in r16, pind
	ldi r17, (1 << PD3)
	and r16, r17
	cpi r16, 0
	ldi r17, (1 << PD5)
	breq TURN_ON_LED1
	
	com r17
	in r18, portd
	and r18, r17
	out portd, r18
	jmp START

	TURN_ON_LED1:
		in r18, portd
		or r18, r17
		out portd, r18
	jmp START
