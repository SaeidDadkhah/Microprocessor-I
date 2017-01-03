;
; io.asm
;
; Created: 1/1/2017 5:31:58 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
.org 0x00 jmp RST_ISR
.org 0x04 jmp INT1_ISR

INT1_ISR:
	cli

	call READ_BUFFER
	call NUM_2_7SEG
	call PUT_NUM

	sei
	ret

RST_ISR:
	cli

	ldi r16, (1 << INT1)
	out GICR, r16
	
	ldi r16, 0x04
	out DDRB, r16
	ldi r16, 0x00
	out DDRA, r16

	sei

END: jmp END

READ_BUFFER:
	; r20: Input device number
	; r21: Input data
	ldi r16, 0x00
	out DDRB, r16
	out DDRA, r16

	nop

	in r20, PINB
	in r21, PINA

	ret

NUM_2_7SEG:
	; Input: Decoded binary number from 0 to 8 in r21
	; r22: 7-Segment code
	cpi r21, 0b11111110
	brne N27S_NOT0
	ldi r22, 0x3F
	jmp N27S_END

	N27S_NOT0:
		cpi r21, 0b11111101
		brne N27S_NOT1
		ldi r22, 0x06
		jmp N27S_END

	N27S_NOT1:
		cpi r21, 0b11111011
		brne N27S_NOT2
		ldi r22, 0x5B
		jmp N27S_END

	N27S_NOT2:
		cpi r21, 0b11110111
		brne N27S_NOT3
		ldi r22, 0x4F
		jmp N27S_END

	N27S_NOT3:
		cpi r21, 0b11101111
		brne N27S_NOT4
		ldi r22, 0x66
		jmp N27S_END

	N27S_NOT4:
		cpi r21, 0b11011111
		brne N27S_NOT5
		ldi r22, 0x6D
		jmp N27S_END

	N27S_NOT5:
		cpi r21, 0b10111111
		brne N27S_NOT6
		ldi r22, 0x7D
		jmp N27S_END

	N27S_NOT6:
		cpi r21, 0b01111111
		brne N27S_NOT7
		ldi r22, 0x07
		jmp N27S_END
		
	N27S_NOT7:
	N27S_END:
		ret

PUT_NUM:
	ldi r16, 0x0F
	out PORTB, r16

	ldi r16, 0xFF
	out DDRA, r16
	out DDRB, r16

	out PORTA, r22

	ldi r16, 0x07
	out PORTB, r16
	ldi r16, 0x00
	out DDRA, r16
	ldi r16, 0x0C
	out DDRB, r16
	ldi r16, 0x00
	out PORTB, r16

	ret
