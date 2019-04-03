/*
 * Lab1.asm
 *
 *  Created: 2019-04-03 13:29:17
 *   Author: adaab301
 */ 


	.def	startBit = r20	; 1 bit siffra
	.def	counter = r21
	ldi		r18,$0A			; Delay T, 5 för T/2
	ldi		r20,$01
	clr		r21
	ldi		r16,HIGH(RAMEND)
	out		SPH,r16
	ldi		r16,LOW(RAMEND)
	out		SPL,r16
	call	INIT


	FOREVER:
		clr		startBit
		sbis	PINA,0
		call	FOREVER
		ldi		r18,5		; Delay = T/2
		call	DELAY
		sbis	PINA,0
		call	FOREVER
		dec		startBit
		clr		r19			; Clearar output
		
	LOOP:
		ldi		r18,10		; Delay = T
		ldi		r23,$01
		ldi		r22,$03
		cpi		startBit,0	
		breq	FOREVER
		call	DELAY
		ldi		r16,PINA	
		andi	r16,$01		; Maskar ut sista biten
		cpse	r16,r23
		lsr		r19
		call	insertBit	
		cpi		counter,$03
		breq	displayOutput
		inc		counter
		call	LOOP
		
		
	displayOutput:
		out		PORTB,r19
		clr		counter
		call	FOREVER

	insertBit:
		ldi		r16,$08
		add		r19,r16
		cpse	counter,r22	
		lsr		r19			; Skifta 1 steg höger
		ret
		
		

	INIT:
		clr	r16
		out DDRA,r16
		ldi	r16,$0F
		out	DDRB,r16
		ret

	DELAY:
		sbi	PORTB,7
		mov	r16,r18		; Decimal bas
	delayYttreLoop:
		ldi	r17,$1F
	delayInreLoop:
		dec	r17
		brne	delayInreLoop
		dec	r16
		brne	delayYttreLoop
		cbi	PORTB,7
		ret
