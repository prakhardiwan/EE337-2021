LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable


Org 0h
	ljmp main


Org 000Bh
	MOV TL0, #0B2H
	MOV TH0, #3CH ;50000 machine cycles = 25ms
	ljmp timer
	
Org 200h
timer:	
	DJNZ R0, do_nothing
delay_1s:
	MOV R0,#40d ;1s done
	
	;depending on r1 extract 4 bits
	CJNE R1,#01d,check2
	;value 1
	MOV	A,71H
	ANL	A,#0F0h
	SWAP A
	MOV	R5,A
	sjmp disp
check2:
	CJNE R1,#02d,check3
	;value 2
	MOV	A,71H
	ANL	A,#0Fh
	MOV	R5,A
	sjmp disp

check3:
	CJNE R1,#03d,check4
	;value 3
	MOV	A,70H
	ANL	A,#0F0h
	SWAP A
	MOV	R5,A
	sjmp disp
	
check4:
	MOV	A,70H
	ANL	A,#0Fh
	MOV	R5,A
	;value 4

	sjmp disp

disp:
	mov a,#89h		 			;Put cursor on first row,8 column
	acall lcd_command	 		;send command to LCD
	acall delay
	mov a,R5
	swap a
	mov p1,a
	swap a
	mov P3,a
	mov dptr,#number_string
	movc a,@a+DPTR
	acall lcd_senddata
	acall delay
	
	mov a,#0C9h		 			;Put cursor on first row,8 column
	acall lcd_command	 		;send command to LCD
	acall delay
	
	MOV R3,#04H	
	MOV A,R5	
	SWAP A
	MOV R4,A
	acall disp_r1
	
	DJNZ R1, do_nothing
load_r1:
	MOV R1,#04h
	RETI
do_nothing:	
	RETI

	
disp_r1:
	MOV A,R4
	CLR C
	RLC A
	MOV R4,A
	CLR A
	MOV ACC.0,C
	MOV DPTR,#Binary_string
	MOVC A,@A+DPTR
	ACALL lcd_senddata
	ACALL delay
	DJNZ R3,disp_r1
	ret
	
Org 100h		
main:
	MOV 70H,#12H
	MOV 71H,#0A0H
		
	mov P2,#00h
	mov P1,#00h
	
	mov r1,#04h
	acall delay
	acall delay

	acall timer_init	;initialise Timer
	acall lcd_init      ;initialise LCD

	acall delay
	acall delay
	acall delay

	mov a,#82h		 			;Put cursor on first row,3 column
	acall lcd_command	 		;send command to LCD
	acall delay
	mov   dptr,#Level_string   ;Load DPTR with sring1 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay
	
	mov a,#0C2h		 			;Put cursor on second row,3 column
	acall lcd_command	 		;send command to LCD
	acall delay
	mov   dptr,#Value_string   ;Load DPTR with sring2 Addr
	acall lcd_sendstring	   ;call text strings sending routine
	acall delay


here:	SJMP here

timer_init:
	MOV 89H, #01H ;mode 1 for timer 0
	MOV TH0, #3CH ;50000 machine cycles = 25ms
	MOV TL0, #0B0H
	SETB EA		  ;enable global interrupt
	SETB ET0	  ;enable timer0 interrupt
	MOV R0, #40d  ;for 1s 
	SETB TCON.4   ;enable timer
	ret

lcd_init:
         mov   LCD_data,#38H  ;Function set: 2 Line, 8-bit, 5x7 dots
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
	     acall delay

         mov   LCD_data,#0CH  ;Display on, Curson off
         clr   LCD_rs         ;Selected instruction register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay
         mov   LCD_data,#01H  ;Clear LCD
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         
		 acall delay

         mov   LCD_data,#06H  ;Entry mode, auto increment with no shift
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en

		 acall delay
         
         ret                  ;Return from routine

;-----------------------command sending routine-------------------------------------
 lcd_command:
         mov   LCD_data,A     ;Move the command to LCD port
         clr   LCD_rs         ;Selected command register
         clr   LCD_rw         ;We are writing in instruction register
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
		 acall delay
    
         ret  
;-----------------------data sending routine-------------------------------------		     
 lcd_senddata:
         mov   LCD_data,A     ;Move the command to LCD port
         setb  LCD_rs         ;Selected data register
         clr   LCD_rw         ;We are writing
         setb  LCD_en         ;Enable H->L
		 acall delay
         clr   LCD_en
         acall delay
		 acall delay
         ret                  ;Return from busy routine

;-----------------------text strings sending routine-------------------------------------
lcd_sendstring:
	push 0e0h
	lcd_sendstring_loop:
	 	 clr   a                 ;clear Accumulator for any previous data
	         movc  a,@a+dptr         ;load the first character in accumulator
	         jz    exit              ;go to exit if zero
	         acall lcd_senddata      ;send first char
	         inc   dptr              ;increment data pointer
	         sjmp  LCD_sendstring_loop    ;jump back to send the next character
exit:    pop 0e0h
         ret                     ;End of routine

;----------------------delay routine-----------------------------------------------------
delay:	 push 0
	 push 1
         mov r0,#1
loop2:	 mov r1,#255
	 loop1:	 djnz r1, loop1
	 djnz r0, loop2
	 pop 1
	 pop 0 
	 ret

;------------- ROM text strings---------------------------------------------------------------
org 300h
Level_string:
        DB   "Level  ", 00H
Value_string:
		DB   "Value: ", 00H
number_string:
		DB "0123456789ABCDEF"
Binary_string:
		DB "01"
end

