;
; eprom_srom.asm
;
; Created: 12/23/2016 11:23:24 PM
; Author : Saeid Dadkhah
;


; Replace with your application code
.org 0x00 jmp RST_ISR

RST_ISR:
	ldi r16, low(RAMEND)
	out SPL, r16
	ldi r16, high(RAMEND)
	out SPH, r16

START:
	; Check read EPROM
	ldi r20, 0x00
	ldi r21, 0x00
	call READ_MEMORY
	
	; Check write SRAM
	ldi r20, 0x00
	ldi r21, 0x10
	ldi r22, 0x34
	call WRITE_MEMORY
	
	; Check read SRAM
	ldi r22, 0x00
	call READ_MEMORY

END: jmp END

//////////////// ;~; Memory ;~; ////////////////
/*
EPROM:
	0000
	0FFF
SRAM1:
	1000
	17FF
SRAM2:
	1800
	1FFF

Address: r21(4..0):r20(7..0)
Data: r22(7..0)

PORTC(7..0): Address(7..0)
PORTD(4..0): Address(12..8)
PORTD(5): Output Enable - Active Low
PORTD(6): Write Enable - Active Low
			This option only works with SRAM mode (Address: 1000..1FFF)
PORTA(7..0): Data(7..0)

Timing is set for Clk = 8 MHz, Period = 119 ns
*/
READ_MEMORY:
	; Store current value of registers
	push r16

	; init
	ldi r16, 0xFF
	out DDRC, r16 ; PORTC: output
	out DDRD, r16 ; PORTD: output
	ldi r16, 0x00
	out DDRA, r16 ; PORTA: input

	out PORTC, r20

	; Select memory
	sbic PORTD, 0x04
	jmp READ_SRAM_6116

	READ_EPROM_2732:
		mov r16, r21
		andi r16, 0x1F
		out PORTD, r16

		; According to datasheet: 450 ns + 1.5 Clk = 3.78 Clk + 1.5 Clk = 5.28 Clk
		; In proteus default value is 200 ns. Since 200 ns is less than the value in datasheet this will also work correctly in simulation.
		nop
		nop
		nop
		nop
		nop
		nop

		in r22, PINA

		jmp FINALIZE_READ_MEMORY

	READ_SRAM_6116:
		mov r16, r21
		andi r16, 0x1F
		ori r16, 0x40 ; Set Write Enable to disable it
		out PORTD, r16

		; 150 ns + 1.5 Clk = 1.26 Clk + 1.5 Clk = 2.76 Clk
		; In proteus default value is 100 ns. Since 100 ns is less than the value in datasheet this will also work correctly in simulation.
		nop
		nop
		nop

		in r22, PINA

		jmp FINALIZE_READ_MEMORY

	FINALIZE_READ_MEMORY:
		sbi PORTD, 0x05
		; Load previous value of registers
		pop r16

		ret

WRITE_MEMORY:
	; Store current value of registers
	push r16

	; Select memory
	mov r16, r21
	andi r16, 0x10
	cpi r16, 0x00
	brne WRITABLE_MEMORY

	; If selected address is not writable, then address is not correct and it should be returned with an error flag.
	; todo: raise an error :D
	jmp FINALIZE_WRITE_MEMORY

	WRITABLE_MEMORY:

		; init
		ldi r16, 0xFF
		out DDRC, r16 ; PORTC: output
		out DDRD, r16 ; PORTD: output
		out DDRA, r16 ; PORTA: output
	
		out PORTC, r20
		out PORTA, r22

		; Memory should be selected

		WRTIE_SRAM_6116:
			mov r16, r21
			andi r16, 0x1F
			ori r16, 0x20 ; Set Output Enable to disable it
			
			out PORTD, r16

			; 90 ns = 0.75 Clk
			nop

			sbi PORTD, 0x06

			; 10 ns = 0.08
			; next instructions (only jmp is enough) will cover this time.

			jmp FINALIZE_WRITE_MEMORY

	FINALIZE_WRITE_MEMORY:
		; Load previous value of registers
		pop r16

		ret
