; This subroutine writes characters on the LCD
LCD_data equ P2    ;LCD Data port
LCD_rs   equ P0.0  ;LCD Register Select
LCD_rw   equ P0.1  ;LCD Read/Write
LCD_en   equ P0.2  ;LCD Enable

org 0000h
ljmp main
org 000bh
// interrupt routine of timer overflow T0
ljmp interrupt_t	

org 100h 
main:
	// Putting values in 70h and 71h 
	mov 70h, #74h
	mov 71h, #0fbh 
	// Taking N = 20,000 for delay
	mov 72h, #0e0h  		// lower byte of -N 
	mov 73h, #0b1h 			// upper byte of -N 
	
	// Reading in Level values 
	mov A, 70h 
	anl A, #0fh		
	mov R2, A	// level-1
	
	mov A, 70h 
	swap A
	anl A, #0fh	
	mov R3, A	// level-2 
	
	mov A, 71h 
	anl A, #0fh		
	mov R4, A	// level-3
	
	mov A, 71h 
	swap A
	anl A, #0fh	
	mov R5, A	// level-4
	
	// Enabling interrupt from T0
	setb EA
	setb ET0
	// Initializing timer count 
	mov 8ch, 73h		// TH0 = 73h 
	mov 8ah, 72h		// TL0 = 72h
	// Enabling the timer T0 to run
	mov 89h, #01h // setting mode 1 and timer 
	mov R6, #64h
	setb TCON.4 // TR0, TCON.5 gives TF0
	
	// Initialization of LCD 
	lcall lcd_init
	
	// indicator bits
	setb 2ch.1 	// Level-1 on 
	clr 2ch.2
	clr 2ch.3
	clr 2ch.4
	
	lcall delay
	lcall delay
	lcall delay
	mov a,#84h		 ;Put cursor on first row,4th column, 0th column is the starting one.
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov  dptr,#level_1   ;Load DPTR with sring1 Addr
	lcall lcd_sendstring	   ;call text strings sending routine
	lcall delay
	
	// second line 
	mov a,#0C2h		  ;Put cursor on second row,2 column
	lcall lcd_command
	lcall delay
	mov   dptr,#value_s
	lcall lcd_sendstring
	lcall delay 
	here: sjmp here 

interrupt_t:
	// restore the count
	mov 8ch, 73h	// TH0 = 73h
	mov 8ah, 72h	// TL0 = 72h
	djnz R6, back
	
	jb 2ch.1, lev1    // Level 1
	jb 2ch.2, levprox2	// Level 2
	jb 2ch.3, levprox3	// Level 3
	jb 2ch.4, levprox4	// Level 4
	
	restore: mov R6, #64h  
	back: reti 
levprox2:
	ljmp lev2
levprox3:
	ljmp lev3
levprox4: 
	ljmp lev4

lev1:
	mov A, R2 
	mov P3, A
	clr 2ch.1 
	setb 2ch.2 
	// write to LCD
	mov a,#84h		 ;Put cursor on first row,1 column, 0th column is the starting one.
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov   dptr,#level_1   ;Load DPTR with sring1 Addr
	lcall lcd_sendstring	   ;call text strings sending routine
	lcall delay
	// second line binary value
	mov A,#0C9h		  ;Put cursor on second row,2 column
	lcall lcd_command
	lcall delay
	mov B, R2 // B gets the value of R2
	ljmp Bin_type3
	
Bin_type3:
	jb B.3, send_31L3
	jnb B.3, send_30L3
	
send_30L3: /// RLC A
	mov   A,#30h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type2

send_31L3: 
	mov   A,#31h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type2
	
Bin_type2:
	jb B.2, send_31L2
	jnb B.2, send_30L2
	
send_30L2: 
	mov   A,#30h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type1

send_31L2: 
	mov   A,#31h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type1

Bin_type1:
	jb B.1, send_31L1
	jnb B.1, send_30L1
	
send_30L1: 
	mov   A,#30h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type0

send_31L1: 
	mov   A,#31h 
	lcall lcd_senddata 
	lcall delay
	ljmp Bin_type0

Bin_type0:
	jb B.0, send_31L0
	jnb B.0, send_30L0
	
send_30L0: 
	mov   A,#30h 
	lcall lcd_senddata 
	lcall delay
	ljmp restore 

send_31L0: 
	mov   A,#31h 
	lcall lcd_senddata 
	lcall delay
	ljmp restore 

lev2: 
	mov A, R3
	mov P3, A
	clr 2ch.2 
	setb 2ch.3
	// write to LCD 
	mov a,#84h		 ;Put cursor on first row,1 column, 0th column is the starting one.
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov   dptr,#level_2   ;Load DPTR with sring1 Addr
	lcall lcd_sendstring	   ;call text strings sending routine
	lcall delay
	// second line binary value
	mov A,#0C9h		  ;Put cursor on second row,2 column
	lcall lcd_command
	lcall delay
	mov B, R3 // B gets the value of R2
	ljmp Bin_type3 

lev3: 
	mov A, R4
	mov P3, A
	clr 2ch.3 
	setb 2ch.4
	// write to LCD
	mov a,#84h		 ;Put cursor on first row,1 column, 0th column is the starting one.
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov   dptr,#level_3   ;Load DPTR with sring1 Addr
	lcall lcd_sendstring	   ;call text strings sending routine
	lcall delay
	// second line binary value
	mov A,#0C9h		  ;Put cursor on second row,2 column
	lcall lcd_command
	lcall delay
	mov B, R4 // B gets the value of R2
	ljmp Bin_type3
 
lev4: 
	mov A, R5
	mov P3, A
	clr 2ch.4 
	setb 2ch.1
	// write to LCD
	mov a,#84h		 ;Put cursor on first row,1 column, 0th column is the starting one.
	lcall lcd_command	 ;send command to LCD
	lcall delay
	mov   dptr,#level_4   ;Load DPTR with sring1 Addr
	lcall lcd_sendstring	   ;call text strings sending routine
	lcall delay
	// second line binary value
	mov A,#0C9h		  ;Put cursor on second row,2 column
	lcall lcd_command
	lcall delay
	mov B, R5 // B gets the value of R2
	ljmp Bin_type3

// LCD routines
;------------------------LCD Initialisation routine----------------------------------------------------
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
;------------------- text strings ------------------------------------
level_1:
         DB   "Level 1", 00H
level_2:
         DB   "Level 2", 00H
level_3:
         DB   "Level 3", 00H
level_4:
         DB   "Level 4", 00H
value_s: 
		 DB   "Value: ", 00H  
 
end
