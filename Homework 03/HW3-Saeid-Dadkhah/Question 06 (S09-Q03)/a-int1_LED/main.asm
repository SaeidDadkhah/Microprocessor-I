;
; a-int1_LED.asm
;
; Created: 11/24/2016 11:48:14 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
.org 0x00 jmp RST_ISR
.org 0x04 jmp EXT_INT1_ISR

EXT_INT1_ISR:
	cli

	ldi r17, (1 << PD4)
	in r16, PORTD
	eor r16, r17
	out PORTD, r16

	sei
	ret

RST_ISR:
	cli

	; init stack
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

	; init port D
	ldi r16, (1 << PD4)
	out DDRD, r16
	ldi r16, (1 << PD3)
	out PORTD, r16

	; init ext int1
	ldi r16, (1 << INT1)
	out GICR, r16
	ldi r16, (1 << INT1)
	out GIFR, r16
	; START: test int mode
		; test low level
			ldi r16, (0 << ISC11) | (0 << ISC10)
		; test toggle
			;ldi r16, (0 << ISC11) | (1 << ISC10)
		; test falling edge
			;ldi r16, (1 << ISC11) | (0 << ISC10)
		; test rising edge
			;ldi r16, (1 << ISC11) | (1 << ISC10)
	; END: test int mode
	out MCUCR, r16

	sei

LAST_LINE: jmp LAST_LINE