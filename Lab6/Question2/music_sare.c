//Header files
#include <at89c5131.h>
#include <stdio.h>	//for sprintf functions

//Bit definitions
sbit IM = P1^4; 		// on when Sa ; off when Re
sbit Music_OP = P0^0;
//Global variables
unsigned char addr = 0x80;
unsigned int count_T1 = 100;

//Timer 0 ISR
void Timer0_Interrupt(void) interrupt 1
{	
			  TF0 = 0;
			  TR0 = 0;
			  Music_OP = !Music_OP;
				if(IM==1){  //sa
					TH0 = 0xef;
					TL0 = 0xb9;
				}
				else{
					TH0 = 0xf1;
					TL0 = 0x88;
				}
			  TR0 = 1;
			  return;
}

//Timer 1 ISR
void Timer1_Interrupt(void) interrupt 3
{		
		TF1 = 0;
		TR1 = 0;
		TH1 = 0x63;
		TL1 = 0xc0;
		TR1 = 1;
		if(count_T1==0){
				IM = !IM;
				count_T1 = 100; 
				return;
		}
		count_T1 = count_T1 - 1;
		return; 
}

void timer_init(void)
{ 		TMOD = 0x11;
			//MOV TCON,#0x01
			ET0 = 1;
			ET1 = 1;
			TH0 = 0xef;
			TH1 = 0x63;
			TL0 = 0xb9;
			TL1 = 0xc0;
			EA = 1;
			TR0 = 1;
			TR1 = 1;
			return;	 
}
//Main function
int main(void)
{	
	timer_init();
	IM = 1;
	Music_OP = 1;
	while(1){
	}
}
	