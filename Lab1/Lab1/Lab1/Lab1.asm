/*
 * Lab1.asm
 *
 *  Created: 2019-04-03 13:29:17
 *   Author: adaab301
 */ 


	.def	startBit = r20	; 1 bit siffra
	ldi		r18,10		; Delay T, 5 för T/2
	.def	counter = r21
	clr		r21
	ldi		r16,HIGH(RAMEND)
	out		SPH,r16
	ldi		r16,LOW(RAMEND)
	out		SPL,r16
	call	INIT


	FOREVER:
		call	hittaStartBit

		
	LOOP:
		ldi		r18,10		; Delay = T
		cpi		startBit,0	
		breq	FOREVER
		call	DELAY
		ldi		r19,PINA	
		andi	r19,$01		; Maskar ut sista biten
		cpi		r19,$01		
		breq	insertBit	; Kollar om input = 1 eller 0		
		lsr		r19			; Om input = 0
		cpi		counter,$03
		breq	displayOutput	; Titta om 4 bitar har hittats
		inc		counter		
		call	LOOP
		
	displayOutput:
		out		PORTB,r19
		clr		counter
		call	FOREVER


	insertBit:
		ldi		r16,$08
		add		r19,r16
		lsr		r19			; Skifta 1 steg höger

	hittaStartBit:
		clr		startBit
		sbic	PINA,0
		dec		startBit	; Första biten = 1
		call	FOREVER
		ldi		r18,5		; Delay = T/2
		call	DELAY
		sbic	PINA,0
		dec		startBit	; Om PINA = 1
		clr		r19			; Clearar output
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
