org 0000h
ljmp main
org 100h
main: 
//Disbling the mosfet for reading 
mov P1, #0fh

//code 
mov A,P1
anl A, #0Fh // A = D, in the test D = 1. 
mov B, A // B = D

mov A, P1

Count:
    LCALL DELAY
	ADD A, #10h // 
	MOV P1, A 
SJMP Count


ORG 300H
DELAY:
    MOV R5, B // AGAIN will get executed D times 
    AGAIN:
        MOV R4,#0d0h
        AGAIN_one: 
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
