#include <reg51.h>

void MSdelay(unsigned int);
unsigned char LookUpTable(unsigned char);

sbit CS = P0^7;					
sbit A1 = P3^4;					
sbit A0 = P3^3;					

sfr LED = 0x90;

void main(void)
{
    unsigned char input; //p2 value
    unsigned char low;
    unsigned char high;
    
    P2 = 0XFF;  //P2 is input
    
    while(1)
    {
        input = ~P2;
        low = input & 0x0F;
        high = input & 0xF0;
        
        high >>= 4;
        
        if((low <= 9)&&(high <= 9)){
            CS = 0;
            A1 = 1;	
            A0 = 1;
		
            P1 = LookUpTable(3);		
            CS = 1;				
		
            MSdelay(5);
        
            CS = 0;
            A0 = 0;
		
            P1 = LookUpTable(high);		
            CS = 1;				
		
            MSdelay(5);
        
            CS = 0;
            A1 = 0;	
            A0 = 1;
		
            P1 = LookUpTable(3);		
            CS = 1;				
		
            MSdelay(5);
        
            CS = 0;
            A0 = 0;
		
            P1 = LookUpTable(low);		
            CS = 1;				
		
            MSdelay(5);
        }else{
            LED = 0x55;
            MSdelay(5);
            LED = 0xAA;            
            MSdelay(5);
        }//end of if
    }//end of while
}
    
void MSdelay(unsigned int itime)
{
    unsigned int i,j;
    for(i = 0 ; i < itime ; i++)
         for(j = 0 ; j < 1275 ; j++);
}

unsigned char LookUpTable(unsigned char num){
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
