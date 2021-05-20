org 0000h
ljmp main
org 000bh
// interrupt routine of timer overflow T0
ljmp interrupt_t	

org 100h 
main:
	// Taking N = 20,000 as input and calculating -N 
	mov R0, #20h  		// lower byte of N 
	mov A, R0
	cpl A
	mov R2, A
	mov R1, #4eh 			// upper byte of N
	mov A, R1
	cpl A
	mov R1,A
	mov A,R2
	inc A
	jc addone
	mov R0,A
	
	// Enabling interrupt from T0
	setb EA
	setb ET0
	// Initializing timer count 
	mov 8ch, R1		// TH0 = R1 
	mov 8ah, R0		// TL0 = R0	 
	// Enabling the timer T0 to run
	mov 89h, #01h // setting mode 1 and timer 
	mov A, #0ffh
	mov R3, #64h
	setb TCON.4 // TR0, TCON.5 gives TF0
	here: sjmp here 
addone: 
inc R1
ret

org 300h 
interrupt_t:
	// restore the count
	mov 8ch, R1		// TH0 = R1 
	mov 8ah, R0		// TL0 = R0
	djnz R3, Blink 
	//Configuring the I/0
	cpl A 
	mov P1, A  // Setting P1.7 to P1.0 as HIGH
	mov R3, #64h  
	Blink: reti 
end
