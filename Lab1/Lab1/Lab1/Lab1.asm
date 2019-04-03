/*
 * Lab1.asm
 *
 *  Created: 2019-04-03 13:29:17
 *   Author: adaab301
 */ 



 DELAY:
	sbi	PORTB,7
	ldi	r16,10		; Decimal bas
delayYttreLoop:
	ldi	r17,$1F
delayInreLoop:
	dec	r17
	brne	delayInreLoop
	dec	r16
	brne	delayYttreLoop
	cbi	PORTB,7
	ret
