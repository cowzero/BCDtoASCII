		ORG 	0
		MOV		DPTR, #300H
		MOV 	P2, #0FFH

MAIN:	MOV 	A, P2
		CPL 	A
		MOV 	R0, A ;BACK UP

		ANL 	A, #0FH
		MOV 	R1, A ;LOW NIBBLE
		MOV 	A, R0
		ANL 	A, #0F0H
		SWAP 	A
		MOV 	R2, A ;HIGH NIBBLE
		
		CJNE	R1, #10, TST1
TST1:	JNC		TOGGLE
		CJNE	R2, #10, TST2
TST2:	JNC		TOGGLE

		MOV		P1,#0FFH
		CLR		P0.7
		SETB	P3.4
		SETB	P3.3
		MOV		A, #3			
		MOVC 	A, @A+DPTR			
		MOV		P1, A
		SETB	P0.7
		CALL	DELAY
		MOV		P1,#0FFH

		CLR		P0.7
		CLR		P3.3
		MOV		A, R2			
		MOVC 	A, @A+DPTR			
		MOV		P1, A
		SETB	P0.7
		CALL	DELAY
		MOV		P1,#0FFH

		CLR		P0.7
		CLR		P3.4
		SETB	P3.3
		MOV		A, #3			
		MOVC 	A, @A+DPTR			
		MOV		P1, A
		SETB	P0.7
		CALL	DELAY
		MOV		P1,#0FFH

		CLR		P0.7
		CLR		P3.3
		MOV		A, R1			
		MOVC 	A, @A+DPTR			
		MOV		P1, A
		SETB	P0.7
		CALL	DELAY
		MOV		P1,#0FFH
		
		LJMP	MAIN

TOGGLE: MOV		P1, #55H
		CALL	DELAY
		MOV		P1,	#0AAH
		CALL	DELAY
		LJMP	MAIN

;-------SUBROUTINE--------
DELAY:	MOV		R4, #100		;����
AGAIN:	MOV		R3, #11
HERE:	NOP
		NOP	
		DJNZ	R3, HERE
		DJNZ	R4, AGAIN
		RET

;------LOOK UP TABLE------
ORG 300H
TABLE:				;LOOK UP TABLE
DB	192,249,164,176,153,146,130,216,128

END
