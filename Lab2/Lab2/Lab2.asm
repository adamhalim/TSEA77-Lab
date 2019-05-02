.def    char = r18
.def    char_bin = r19
.def    beep_length = r20
.def	N_length = r24
ldi		N_length,$55
 
ldi     r16,HIGH(RAMEND)
out     SPH,r16
ldi     r16,LOW(RAMEND)
out     SPL,r16
ldi     r16,$01
out     DDRB,r16
 
 
 
MORSE:
            ldi ZL,LOW(MESSAGE*2)
            ldi ZH,HIGH(MESSAGE*2)
            rcall GET_CHAR
			LOOP:
            breq KLAR
            rcall LOOKUP
            rcall SEND
            ldi beep_length,$03
            rcall NO_BEEP
			rcall GET_CHAR
			cpi char,$00
			brne LOOP
            rjmp MORSE
LOOKUP:
            push ZL
            push ZH
            ldi ZH,HIGH(BTAB*2)
            ldi ZL,LOW(BTAB*2)
            subi char,$41 ;ändra till 40 med space sedan.
			ldi r22, 1 
            add ZL,char
			brcc pc+2
			add	ZH, r22
            lpm char_bin,Z
            pop ZH
            pop ZL
            ret
GET_CHAR:
            lpm char,Z+
            ret
SEND:
            rcall GET_BIT
            cpi char_bin,$00
            breq CHAR_DONE
            rcall BEEP
            ldi beep_length,$01
            rcall NO_BEEP
            rjmp SEND
char_done:  ret
GET_BIT:
            ldi beep_length,$01
            sbrc char_bin,7
            ldi beep_length,$03
            lsl char_bin
            ret
						
BEEP:
			ldi	r22, $55
BEEPLOOP:
            rcall CYCLE1
            dec r22
            brne BEEPLOOP
			dec beep_length
			brne BEEP
			ldi	beep_length, $01
	        ret
NO_BEEP:
			set
            rcall CYCLE1
			clt
            dec N_length
            brne NO_BEEP
            ret
CYCLE1:
			brts pc+2
            sbi	PORTB,0
            rcall DELAY
            cbi PORTB,0
            rcall DELAY
            ret
CYCLE2:    
            cbi PORTB,0
            rcall DELAY
            cbi PORTB,0
            rcall DELAY
            ret
KLAR:
DELAY:
            ldi r16,$01
delayYttreLoop:
            ldi r17,$AA
delayInreLoop:
            dec r17
            brne delayInreLoop
            dec r16
            brne delayYttreLoop
            ret
           
.org $200
MESSAGE:    .db "DATORTEKNIK",$00
 
.org $230
BTAB:       .db $60, $88, $A8, $90, $40, $28, $D0, $08, $20, $78, $B0, $48, $E0, $A0, $F0, $68, $D8, $50, $10, $C0, $30, $18, $70, $98, $B8, $C8