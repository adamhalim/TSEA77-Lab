.def	counter = r17

.org	$0000
rjmp	START
.org	INT0addr
rjmp	NUMBER
.org	INT1addr
rjmp	MUX

 START:
		ldi		r16, LOW(RAMEND)
		out		SPL, r16
		ldi		r16, HIGH(RAMEND)
		out		SPH, r16
		ldi		r16, $03
		out		DDRA, r16
		ldi		r16, $7F
		out		DDRB, r16
		ldi		r16, (1<<ISC01 | 0<<ISC00 | 1<<ISC11 | 0<<ISC10)
		out		MCUCR, r16
		ldi		r16, (1<<INT0 | 1<<INT1)
		out		GICR, r16
		sei 
WAIT:
		rjmp	WAIT

MUX: 
		push	r16
		ldi		ZL, LOW(TIME)
		ldi		ZH, HIGH(TIME)
		add		ZL, counter
		ld		r16, Z
		ldi		ZL, LOW(2*BCD_CODE)
		ldi		ZH, HIGH(2*BCD_CODE)
		add		ZL, r16
		lpm		r16, Z
		out		PORTA, counter
		out		PORTB, r16
		inc		counter
		cpi		counter, 4
		brne	MUX_COMP
		clr		counter
MUX_COMP:
		pop		r16
		reti
NUMBER:
		push	r16
		ldi		ZL, LOW(TIME)
		ldi		ZH, HIGH(TIME)
		ld		r16, Z
		inc		r16
		st		Z, r16
		cpi		r16, 10
		brne	NUMBER_RET
		clr		r16
		st		Z+, r16
		ld		r16, Z
		inc		r16
		st		Z, r16
		cpi		r16,6
		brne	NUMBER_RET
		clr		r16
		st		Z+, r16
		ld		r16, Z
		inc		r16
		st		Z, r16
		cpi		r16,10
		brne	NUMBER_RET
		clr		r16
		st		Z+, r16
		ld		r16, Z
		inc		r16
		st		Z,r16
		cpi		r16,6
		brne	NUMBER_RET
		clr		r16
		st		Z,r16
NUMBER_RET:
		pop		r16
		reti

.dseg
.org $100
TIME: .byte 4 

.cseg
.org 200
BCD_CODE:	.db $3F,$30,$5B,$4F,$66,$6D,$7D,$07,$FF,$67