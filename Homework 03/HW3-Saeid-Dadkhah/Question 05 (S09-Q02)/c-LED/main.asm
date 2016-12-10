;
; c-LED.asm
;
; Created: 11/20/2016 10:53:15 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
; Replace with your application code
.org 0x00 jmp RST_ISR
.org 0x04 jmp EXT_INT1_ISR

EXT_INT1_ISR:
	cli

	ldi r16, (1 << PD5)
	out PORTD, r16

	sei
	ret

RST_ISR:
	cli

	ldi r16, (1 << PD4)
	out ddrd, r16

	ldi r16, (1 << PD6)
	out portd, r16
	
	sei

START:
	in r16, pind
	ldi r17, (1 << PD6)
	and r16, r17
	cpi r16, 0
	brne START

	ldi r20, 0xA
	BLINK:
		call TURN_ON
		call TURN_OFF
		dec r20
		cpi r20, 0
		brne BLINK

	jmp START

TURN_ON:
	in r16, portd
	ldi r17, (1 << PD4)
	or r16, r17
	out portd, r16
	call DELAY
	ret

TURN_OFF:
	in r16, portd
	ldi r17, (1 << PD4)
	com r17
	and r16, r17
	out portd, r16
	call DELAY
	ret

DELAY:
	ldi r16, 0
	LOOP1:
		ldi r17, 0
		LOOP2:
			ldi r18, 0
			LOOP3:
				inc r18
				cpi r18, 0x4
				brne LOOP3
			inc r17
			cpi r17, 0x80
			brne LOOP2
		inc r16
		cpi r16, 0x80
		brne LOOP1
	ret
