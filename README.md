# BCDtoASCII
① 개요
- 8bit 스위치로 Packed BCD코드를 입력 받아 FND에 아스키 코드를 출력한다.
- 스위치가 눌러진 상태는 ‘1’, 눌러지지 않은 상태는 ‘0’으로 한다.
- 올바른 Packed BCD코드가 입력되지 않았을 경우 LED를 toggle한다.
 
② 사용된 입출력 장치의 구조 및 분석
- 8051 (INTEL)


파란 박스의 범위의 스위치를 보면, 풀업 스위치임을 알 수 있다. 이는 스위치를 누르지 않을 경우 +V값이 P2으로 들어가고, 스위치를 누르게 될 경우 접지에 연결되어 GND값이 P2의 입력 값으로 들어간다는 것이다. 즉, 스위치를 누르지 않았을 때 P2의 입력으로 1의 값이, 스위치를 누르게 되면 P2의 입력으로 0의 값이 들어간다.


③소스 코드

④고찰

초록 박스의 범위의 LED를 보면, 풀업 다이오드임을 알 수 있다. 즉 P1에 0을 입력하면 불이 켜지고, 1을 입력하면 불이 꺼진다.




왼쪽의 그림은 Common-Anode 형 7-SEG의 내부 구조이다. 각각의 SEGMENT는 다이오드로 이루어져 있으며, 다이오드에 정방향 전류가 흐르기 위해선, Vcc에 1의 입력이(CS = 1), 각 abcdefg- 단자에는 0의 입력이 들어와야 한다는 것을 알 수 있다. 
추가적으로 7-SEG에서 여러 숫자를 출력하기 위해서는, 동시에 다른 숫자를 4개의 7-SEG에 표시할 수 없기 때문에, 각 자리가 돌아가며 빠른 속도로 켜졌다 꺼졌다 하며 눈의 잔상효과를 이용해야 한다. 3*8 DECODER이므로 각 자리를 선택하기 위해 A1과 A0에 적절한 값을 넣어주면 된다. A1과 A0에 11을 넣으면 DISP3, 10은 DISP2, 01은 DISP1, 00은 DISP0을 선택할 수 있다.



다음은 7-SEGMENT에 숫자를 표시하기 위해서 각 SEGMENT에 넣어야 하는 값이 정리된 표이다.
이는 LOOK UP TABLE에서 참조할 것이다.


BINARY
DEC
핀
P1.7
P1.6
P1.5
P1.4
P1.3
P1.2
P1.1
P1,0
-
연결
dp
g
f
e
d
c
b
a
-
0
1
1
0
0
0
0
0
0
192
1
1
1
1
1
1
0
0
1
249
2
1
0
1
0
0
1
0
0
164
3
1
0
1
1
0
0
0
0
176
4
1
0
0
1
1
0
0
1
153
5
1
0
0
1
0
0
1
0
146
6
1
0
0
0
0
0
1
0
130
7
1
1
0
1
1
0
0
0
216
8
1
0
0
0
0
0
0
0
128
9
1
0
0
1
0
0
0
0
144
A
1
0
0
0
1
0
0
0
136
B
0
0
0
0
0
0
0
0
0
C
1
1
0
0
0
1
1
0
198
D
0
1
0
0
0
0
0
0
64
E
1
0
0
0
0
1
1
0
134
F
1
0
0
0
1
1
1
0
142

<LOOK UP TABLE 참조표>

다음은 0 ~ 9까지 숫자 각각의 BCD코드와 아스키코드가 정리된 표이다.

KEY
ASCII(HEX)
BCD(Unpacked)
0
30
0000 0000
1
31
0000 0001
2
32
0000 0010
3
33
0000 0011
4
34
0000 0100
5
45
0000 0101
6
36
0000 0110
7
37
0000 0111
8
38
0000 1000
9
39
0000 1001

<ASCII – BCD>










③ 실행 결과
1) ASSEMBLY 언어

- PACKED BCD : 0000 0000 (00)
왼쪽부터 차례대로 3030이 출력됐고, 올바른 ASCII CODE를 표시하였다.

- 올바른 PACKED BCD코드를 입력하지 않은 경우 : 1100 0000
올바른 입력이 아니므로 LED가 토글한다.


2) C 언어

- PACKED BCD : 0010 1001 (29)
왼쪽부터 차례대로 3030이 출력됐고, 올바른 ASCII CODE를 표시하였다.

- 올바른 PACKED BCD코드를 입력하지 않은 경우 : 1010 1111
올바른 입력이 아니므로 LED가 토글한다.


④ 소스 코드

1) ASSEMBLY 언어

	ORG 	0				; PC = 0번지부터 시작
	MOV	DPTR, #300H			; DPTR은 300H번지를 가리킴
	MOV 	P2, #0FFH			; P2는 INPUT

MAIN:	MOV 	A, P2				; P2값을 읽어와
	CPL 	A				; 반전 시킨다(스위치를 눌렀을 때 1이어야 하므로)
	MOV 	R0, A 				; 그 값을 저장해 놓는다

	ANL 	A, #0FH			; 히위 니블 값을 얻기 위해 마스킹 해서
	MOV 	R1, A 				; R1에 저장한다
	MOV 	A, R0				; 백업해놓은 스위치 값을 다시 불러와
	ANL 	A, #0F0H			; 상위 니블 값을 얻기 위해 마스킹한 후
	SWAP 	A				; 하위 니블과 교체하여 UPACKED BCD로 만든 후
	MOV 	R2, A 				; R2에 저장한다

						; 하위 니블 값을 10과 비교하고 값이 일치하든 그		CJNE	R1, #10, TST1			렇지 않든 무조건 다음 문장으로 가 C를 비교한다 
TST1:	JNC	TOGGLE			; 10과 같거나 큰 경우에는 C가 0이므로 TOGGLE,
	CJNE	R2, #10, TST2			; 상위 니블 값도 마찬가지로 
TST2:	JNC	TOGGLE			; C를 검사해서 TOGGLE로 간다

	MOV	P1,#0FFH			; P1에 값이 남아 있을 수 있으므로 초기화
	CLR	P0.7				; CS = 0, 7-SEG를 끈다
	SETB	P3.4				; DISP3 선택
	SETB	P3.3
	MOV	A, #3				
	MOVC 	A, @A+DPTR			; LOOK UP TABLE을 참조하여
	MOV	P1, A				; 3을 출력한다
	SETB	P0.7				; CS = 1, 7-SEG를 켠다
	CALL	DELAY				; 약간의 지연시간을 가진 후
	MOV	P1,#0FFH			; P1 초기화

	CLR	P0.7				; CS = 0, 7-SEG를 끈다
	CLR	P3.3				; DISP2 선택
	MOV	A, R2				; 상위 니블 값을
	MOVC 	A, @A+DPTR			; LOOK UP TABLE을 참조하여
	MOV	P1, A				; 출력한다
	SETB	P0.7				; CS = 1, 7-SEG를 켠다
	CALL	DELAY				; 약간의 지연시간을 가진 후
	MOV	P1,#0FFH			; P1 초기화

	CLR	P0.7				; CS = 0, 7-SEG를 끈다
	CLR	P3.4				; DISP1 선택
	SETB	P3.3				
	MOV	A, #3				
	MOVC 	A, @A+DPTR			; LOOK UP TABLE을 참조하여
	MOV	P1, A				; 3을 출력한다
	SETB	P0.7				; CS = 1, 7-SEG를 켠다
	CALL	DELAY				; 약간의 지연시간을 가진 후
	MOV	P1,#0FFH			; P1 초기화

	CLR	P0.7				; CS = 0. 7-SEG를 끈다
	CLR	P3.3				; DISP0 선택
	MOV	A, R1				; 하위 니블 값을
	MOVC 	A, @A+DPTR			; LOOK UP TABLE을 참조하여
	MOV	P1, A				; 출력한다
	SETB	P0.7				; CS = 1, 7-SEG를 켠다
	CALL	DELAY				; 약간의 지연시간을 가진 후
	MOV	P1,#0FFH			; P1 초기화
		
	LJMP	MAIN				; 다시 돌아가서 모니터 한다

TOGGLE: MOV	P1, #55H			; 잘못된 값을 입력한 경우 이곳으로 들어와
	CALL	DELAY				
	MOV	P1, #0AAH			; LED를 TOGGLE 한다
	CALL	DELAY
	LJMP	MAIN				; 다시 돌아가서 모니터 한다

;-----------SUBROUTINE------------
DELAY:	MOV	R4, #100			; 5MS 딜레이
AGAIN:	MOV	R3, #11
HERE:	NOP
	NOP	
	DJNZ	R3, HERE
	DJNZ	R4, AGAIN
	RET

;----------LOOK UP TABLE----------	; 7-SEG값을 가지고 있는 테이블
	ORG 	300H
DB	192,249,164,176,153,146,130,216,128,144

END


* 지연시간 
HERE LOOP : (4 * 11) * 1.085us = 47.74us 
AGAIN LOOP : 100 * 47.74us = 4774s  
ELSE : (3 * 100 * 1.085) = 325.5us 
총 지연시간 = 4774 + 325.5 = 5099.5us ≒ 5ms


2) C 언어

#include <reg51.h>

void MSdelay(unsigned int);
unsigned char LookUpTable(unsigned char);

sbit CS = P0^7;					
sbit A1 = P3^4;					
sbit A0 = P3^3;					

sfr LED = 0x90;

void main(void)
{
    unsigned char input; 			; 입력값을 담을 변수
    unsigned char low;				; 하위 니블 값을 담을 변수
    unsigned char high;				; 상위 니블 값을 담을 변수
    
    P2 = 0XFF;  				; P2는 INPUT
    
    while(1)
    {
        input = ~P2;				; P2값을 반전 시킨다(스위치를 눌렀을 때 1이어야 하므로)
        low = input & 0x0F;			; 입력 값을 마스킹하여 하위 니블 저장
        high = input & 0xF0;			; 입력 값을 마스킹하여 상위 니블 저장
        
        high >>= 4;				; 상위 니블을 이동해 UNPACKED BCD로 만든다
        
        if((low <= 9)&&(high <= 9)){ 		; 올바른 입력값일 경우
            CS = 0;				; 7-SEG를 끈다
            A1 = 1;				; DISP3 선택	
            A0 = 1;		
            P1 = LookUpTable(3);		; LOOK UP TABLE을 참조하여 3 출력
            CS = 1;				; 7-SEG를 켠다
            MSdelay(5);				; 약간의 지연시간을 가진다
        
            CS = 0;				; 7-SEG를 끈다
            A0 = 0;				; DISP2 선택
            P1 = LookUpTable(high);		; LOOK UP TABLE을 참조하여 상위 니블 값 출력
            CS = 1;				; 7-SEG를 켠다
            MSdelay(5);
        
            CS = 0;				; 7-SEG를 끈다
            A1 = 0;				; DISP1 선택
            A0 = 1;
            P1 = LookUpTable(3);		; LOOK UP TABLE을 참조하여 3 출력
            CS = 1;				; 7-SEG를 켠다
            MSdelay(5);				; 약간의 지연시간을 가진다
        
            CS = 0;				; 7-SEG를 끈다
            A0 = 0;				; DISP0 선택		
            P1 = LookUpTable(low);		; LOOK UP TABLE을 참조하여 하위 니블 값 출력
            CS = 1;				; 7-SEG를 켠다		
            MSdelay(5);				; 약간의 지연시간을 가진다

        }else{					; 잘못된 입력값인 경우
            LED = 0x55;			; LED를 TOGGLE 한다
            MSdelay(5);				
            LED = 0xAA;            
            MSdelay(5);
        }
    }
}
    
void MSdelay(unsigned int itime)			; MS단위 지연시간을 가지는 함수
{
    unsigned int i,j;
    for(i = 0 ; i < itime ; i++)
         for(j = 0 ; j < 1275 ; j++);
}

unsigned char LookUpTable(unsigned char num){; 7-SEG값을 반환하는 함수 
    switch(num)
	{
		case(0) :   return 192;
		case(1) :   return 249;
		case(2) :   return 164;
		case(3) :   return 176;
		case(4) :   return 153;
		case(5) :   return 146;
		case(6) :   return 130;
		case(7) :   return 216;
		case(8) :   return 128;
		case(9) :   return 144;
	}
}


⑤ ASSEMBLY 와 C언어 비교 분석

ASSEMBLY 언어
C언어
        MOV 	A, P2			
	CPL 	A			
	MOV 	R0, A 		
        ANL 	A, #0FH		
	MOV 	R1, A 			
	MOV 	A, R0			
	ANL 	A, #0F0H		
	SWAP 	A	
	MOV 	R2, A 
        input = ~P2;
        low = input & 0x0F;			high = input & 0xF0;		
        high >>= 4;				
        
ASSEMBLY에서는 논리연산이나 보수를 취하기 위해 A에 옮겨서 수행한 후 다시 가져와야 하지만,
C에서는 그런 수고로움이 없다.
CJNE	R1, #10, TST1			 
TST1:	JNC	TOGGLE		
	CJNE	R2, #10, TST2		
TST2:	JNC	TOGGLE		
if((low <= 9)&&(high <= 9))
C에서는 값의 범위를 비교하기 편하지만 ASSEMBLY에서는 CARRY값을 비교해야 한다. 비교방법이 CJNE를 사용하는 것 말고도 SUB명령어를 사용해서 비교할 수도 있었지만, 그 경우에는 A에 옮겨 담아야 하므로 명령어가 더 많아져서 사용하지 않았다.
DELAY:	MOV	R4, #100		AGAIN:	MOV	R3, #11
HERE:	NOP
	NOP	
	DJNZ	R3, HERE
	DJNZ	R4, AGAIN
	RET
void MSdelay(unsigned int itime)		{
    unsigned int i,j;
    for(i = 0 ; i < itime ; i++)
         for(j = 0 ; j < 1275 ; j++);
}

ASSEMBLY에서의 서브루틴은 C에서 함수로 사용한다.
        MOV	A, R1			
	MOVC 	A, @A+DPTR		
	MOV	P1, A			
P1 = LookUpTable(low);
ASSEMBLY에서 LOOK UP TABLE은 C에서 함수로 사용한다. 이 때, ASSEMBLY에서는 참조하기 위해 A에 값을 옮겨 담아야 하지만 C에서는 그저 함수를 호출하기만 하면 된다.
