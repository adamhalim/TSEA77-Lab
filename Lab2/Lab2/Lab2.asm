.def    char = r18
.def    char_bin = r19
.def    beep_length = r20
.def    no_beep_length = r21
.def	N_length = r24
 
ldi     r16,HIGH(RAMEND)
out     SPH,r16

ldi     r16,LOW(RAMEND)
out     SPL,r16
ldi     r16,$01
out			DDRB,r16
 
 .equ		SPEED=$02
 
MORSE:
			ldi		ZL,LOW(MESSAGE*2)
			ldi		ZH,HIGH(MESSAGE*2)
			rcall	GET_CHAR
	LOOP:
			cpi		char,$20
			breq	SPACE
			rcall	LOOKUP
			
			rcall	SEND
NO_CHAR:	rcall	GET_CHAR
			cpi		char,$00
			brne	LOOP
			rjmp	MORSE
SPACE:		ldi		no_beep_length,$07
			ldi		char,$20
			rcall	NO_BEEP
			rjmp	NO_CHAR
LOOKUP:
            push	ZL
            push	ZH
            ldi		ZH,HIGH(BTAB*2)
            ldi		ZL,LOW(BTAB*2)
            subi	char,$40
CONTINUE:	ldi		r22, 1 
            add		ZL,char
			brcc	pc+2
			add		ZH, r22
            lpm		char_bin,Z
            pop		ZH
            pop		ZL
            ret

SEND:		
            rcall	GET_BIT
            cpi		char_bin,$00
            breq	CHAR_DONE	
            rcall	BEEP
            ldi		no_beep_length,$01
			ldi		N_length,$55
            rcall	NO_BEEP
            rjmp	SEND
CHAR_DONE:	ldi		no_beep_length,$03
			rcall	NO_BEEP
			ret
GET_CHAR:
            lpm		char,Z+
            ret
GET_BIT:
            ldi		beep_length,$01
            sbrc	char_bin,7
            ldi		beep_length,$03
            lsl		char_bin
            ret
						
BEEP:
			ldi		N_length,$55
BEEPLOOP:
            rcall	CYCLE1
            dec		N_length
            brne	BEEPLOOP
			dec		beep_length
			brne	BEEP
			ldi		beep_length, $01
	        ret
NO_BEEP:
			set
            rcall	CYCLE1
			clt
            dec		N_length
            brne	NO_BEEP
			dec		no_beep_length
			brne	NO_BEEP
            ret
CYCLE1:
			brts	pc+2
            sbi		PORTB,0
            rcall	DELAY
            cbi		PORTB,0
            rcall	DELAY
            ret
DELAY:
            ldi		r16,SPEED
delayYttreLoop:
            ldi		r17,$22
delayInreLoop:
            dec		r17
            brne	delayInreLoop
            dec		r16
            brne	delayYttreLoop
            ret
           
.org $200
MESSAGE:    .db "SOS   SOS",$00
 
.org $230
BTAB:       .db $00, $60, $88, $A8, $90, $40, $28, $D0, $08, $20, $78, $B0, $48, $E0, $A0, $F0, $68, $D8, $50, $10, $C0, $30, $18, $70, $98, $B8, $C8