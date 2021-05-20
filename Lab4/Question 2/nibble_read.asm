org 0000h
ljmp main
org 100h
main: 
lcall readNibble 
sjmp main 

readNibble:
	//Configuring the I/0  
	mov A,#0ffh 
	mov P1, A  // Setting P1.7 to P1.0 as HIGH
	lcall DELAY  // 5 seconds delay
	mov A, P1 // A gets the user input 
	anl A, #0fh //setting higher nibble to 0
	mov 4eh, A    // storing value in 4eh's lsbs
	swap A
	mov P1, A	// setting P1.7-P1.4 as per inputs in P1.3 to P1.0
	lcall DELAY  // 5 seconds delay
ret 

ORG 300H
DELAY: // 5s wait
    MOV R5, #14h // 20 * 250 ms = 5s
    AGAIN: // 250 ms/iteration
        MOV R4,#0d0h
        AGAIN_one: 
			NOP
			NOP
			MOV R3, #0dah
			AGAIN_two:
				MOV R2, #04h // 1 cycle
				AGAIN_three:
					DJNZ R2, AGAIN_three 
				DJNZ R3, AGAIN_two 
        DJNZ R4,AGAIN_one
    DJNZ R5,AGAIN
RET
END
