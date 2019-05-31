/*
 * LAX_DEMO2.asm
 *
 *  Created: 2019-05-31 15:22:49
 *   Author: adaab301
 */ 
 .def counter = r17
 .def display = r18

 .org $0000
 rjmp START
 .org INT0addr
 rjmp NUMBER
 .org INT1addr
 rjmp OUTPUT

START:
	ldi		r16, LOW(RAMEND)
	out		SPL, r16
	ldi		r16, HIGH(RAMEND)
	out		SPH, r16
	clr		r17
	clr		r18
IO:
	ldi		r16, $0F
	out		DDRA, r16
INIT_INT:
	ldi r16, (1<<ISC01 | 0<<ISC00 | 1<<ISC11 | 0<<ISC10)
    out MCUCR, r16
    ldi r16, (1<<INT0 | 1<<INT1)
    out GICR, r16
    sei
WAIT:
	rjmp WAIT

NUMBER:
	cpi counter, $0F
	breq PC+2
	inc	counter
	reti
OUTPUT:
	out PORTA, counter
	clr counter
	reti
