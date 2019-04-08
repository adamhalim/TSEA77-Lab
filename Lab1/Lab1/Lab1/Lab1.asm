/*
 * Lab1.asm
 *
 *  Created: 2019-04-03 13:29:17
 *   Author: adaab301
 */ 


.def counter = r21
	clr	counter 

	ldi r16,HIGH(RAMEND)
	out SPH,r16
	ldi	r16,LOW(RAMEND)
	out SPL,r16
	rcall INIT
	clr	  r19

STARTBIT:
	sbis PINA,0
	rjmp STARTBIT
	ldi r18,7		;Delay T/2
	rcall DELAY
	sbis PINA,0
	rjmp STARTBIT
	ldi r18,2*7		;Delay
DATABIT:
	lsr r19
	clr r22
	rcall DELAY
	sbic PINA,0
	ldi	r22,$08
	add r19,r22
	inc counter	; Z
	cpi counter,$04
	breq DATABIT
	;rjmp DATABIT
DISPLAY:
	out PORTB,r19
	clr r19
	clr counter
	;rcall DELAY
	rjmp STARTBIT

INIT:
	clr r16
	out DDRA,r16
	ldi r16,$0F
	out DDRB,r16
	ret

DELAY:
	sbi PORTB,7
	mov r16,r18
delayYttreLoop:
	ldi r17,$1F
delayInreLoop:
	dec r17
	brne delayInreLoop
	dec r16
	brne delayYttreLoop
	cbi PORTB,7
	ret