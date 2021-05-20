//Header files
#include <at89c5131.h>
#include <stdio.h>	//for sprintf functions

//Bit definitions
sbit RS=P0^0;
sbit RW=P0^1;	//Also can use P0^1 or 0x80^1
sbit EN=P0^2;
sbit SW1=P1^0;
sbit LED = P1^4;
sbit prev_SW1 = P0^4;
//Global variables
unsigned char addr = 0x80;
unsigned int overflow_C  = 0;
//LCD functions
void lcd_init(void);
void lcd_cmd(unsigned int i);
void lcd_char(unsigned char ch);
void lcd_write_string(unsigned char *s);
void port_init(void);

//Extern functions from assembly files
extern void timer_init(void);
extern void init(void);
extern void timer0_int(void);

//Timer 0 ISR
void Timer0_Interrupt(void) interrupt 1
{	
		overflow_C = overflow_C+1;
		timer0_int();
}


//Delay function for time*1ms
void msdelay(unsigned int time)
{
	int i,j;
	for(i=0;i<time;i++)
	{
		for(j=0;j<318;j++);
	}
}
//LCD utility functions
void lcd_cmd(unsigned int i)
{
	RS=0;
	RW=0;
	EN=1;
	P2=i;
	msdelay(10);
	EN=0;
}
void lcd_char(unsigned char ch)
{
	RS=1;
	RW=0;
	EN=1;
	P2=ch;
	msdelay(10);
	EN=0;
}
void lcd_write_string(unsigned char *s)
{
	while(*s!='\0')		//Can use while(*s)
	{
		lcd_char(*s++);
	}
}
void lcd_init(void) using 3
{
	lcd_cmd(0x38);
	msdelay(4);
	lcd_cmd(0x06);
	msdelay(4);
	lcd_cmd(0x0C);
	msdelay(4);
	lcd_cmd(0x01);
	msdelay(4);
}

//Port initialization
void port_init(void)
{
	P2=0x00;
	EN=0;
	RS=0;
	RW=0;
}

//Main function
int main(void)
{
	unsigned char str[]="IITB";
	unsigned char str2[16];
	unsigned int loop_count = 0;
	port_init();
	lcd_init();
	init(); // giving values to 81h and 82h for count
	timer_init();
	//lcd_cmd(0x80);
	//lcd_write_string(str);
	while(1)
	{
		lcd_cmd(0x80);
		sprintf(str2,"   Toggle SW1   ");
		lcd_write_string(str2);
		msdelay(10);
		lcd_cmd(0xC0);
		sprintf(str2," when LED glows ");
		lcd_write_string(str2);
		msdelay(2000); // delay of 2 seconds
		prev_SW1 = SW1;
		timer_init();		//initialize timer
		overflow_C  = 0;
		LED = 1;
		
		// wait for switch to occur
		while(SW1==prev_SW1){
		}
		LED = 0;
		//display the reaction time on lcd
		lcd_cmd(0x80);
		sprintf(str2,"  Reaction Time ");
		lcd_write_string(str2);
		msdelay(10);
		lcd_cmd(0xC0);
		sprintf(str2,"Count is %2.2bX %2.2bX%2.2bXh",overflow_C,TH0,TL0);
		lcd_write_string(str2);
		msdelay(5000); // delay of 5 seconds
		//Reset the timer values 
		overflow_C  = 0;
	}
}
	

lcd_cmd(0x80);
sprintf(str1,"%c%c%c%c%c%c%c%c  %d",char_q,char_w,char_e,char_r,char_t,char_y,char_u,char_i, num_moves);
lcd_write_string(str1);
msdelay(10);
lcd_cmd(0xC0);
sprintf(str2,"%c%c%c%c%c%c%c%c  %d",char_a,char_s,char_d,char_f,char_g,char_h,char_j,char_k, min_mov);
lcd_write_string(str2);