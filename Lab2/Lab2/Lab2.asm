/*
 * Lab2.asm
 *
 *  Created: 2019-05-01 14:20:44
 *   Author: adaab301
 */ 

 .def		char = r17
 .def		char_bin = r18
 .def		beep_length = r19

			ldi r16,HIGH(RAMEND)
			out SPH,r16
			ldi	r16,LOW(RAMEND)
			out SPL,r16

INIT:		clr	r16
			out DDRA,r16
			ldi	r16,$01
			out DDRB,r16

MESSAGE:	.db "DATORTEKNIK", $00

BTAB:		.db  $60,$88,$A8,$90,$40,$28,$D0,$08,$20,$78,$B0,$48,$E0,$A0,$F0,$68,$48,$50,$10,$C0,$30,$18,$70,$98,$B8,$C8


MORSE:
		ldi		ZL,LOW(MESSAGE*2)
		ldi		ZH,HIGH(MESSAGE*2)
		rcall	GET_CHAR
		cpi		char,$00
		breq	KLAR
		rcall	LOOKUP
		rcall	GET_BIT
		rjmp	MORSE

KLAR:



GET_BIT:
		lsl		char_bin
		cpi		char_bin,$00
		ret
		ldi		beep_length, $03
		brcs	callbeep
		ldi		beep_length, $01
callbeep:		rcall BEEP_N
		rjmp	GET_BIT

BEEP_N:
		sbi		PORTB,$0
		rcall	DELAY
		cbi		PORTB,$0
		ret

DELAY:
		push	r16
		push	r17
		ldi		r16,200
delayYttreLoop:
		mov		r17,beep_length
delayInreLoop:
		dec		r17
		brne	delayInreLoop
		dec		r16
		brne	delayYttreLoop
		pop		r17
		pop		r16
		ret

LOOKUP:
		push	ZL
		push	ZH
		ldi		ZL,LOW(BTAB*2)
		ldi		ZH,HIGH(BTAB*2)
		subi	char,$41
		add		ZL,char
		lpm		char_bin,Z
		pop		ZH
		pop		ZL
		ret

GET_CHAR:
		lpm	char,Z+
		ret


	