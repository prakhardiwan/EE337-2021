org 0000h
ljmp main
org 100h
main: 
//For testing purpose putting in values 
mov 70h, #0FFh;
mov 71h, #0FFh; 

//Calculating for 72h
mov A, 70h	// Acc gets value of reg 70h: xxxxb3b2b1b0
anl A, #0Fh // Getting lower 4 bits and making other bits 0
mov B, A  	// B = 0000_b3b2b1b0 
SWAP A		// A = b3b2b1b0_0000
add A, B 	// A = b3b2b1b0_b3b2b1b0
mov R3, A
RL A
mov R4, A
RL A 
XRL A,R3
XRL A,R4

mov C, ACC.3 
mov B.6, C 
mov C, ACC.1 
mov B.5, C 
mov C, ACC.0 
mov B.4, C 

mov 72h, B

//Calculating for 73h
mov A, 70h	// A gets value of reg 70h: b3b2b1b0xxxx
anl A, #0F0h // Getting upper 4 bits and making other bits 0
mov B, A    // B = b3b2b1b0_0000
SWAP A   	// A = 0000_b3b2b1b0
mov R5, A	// R5 = 0000_b3b2b1b0
add A, B 	// A = b3b2b1b0_b3b2b1b0
mov R3, A
RL A
mov R4, A
RL A 
XRL A,R3
XRL A,R4

mov B, R5
mov C, ACC.3 
mov B.6, C 
mov C, ACC.1 
mov B.5, C 
mov C, ACC.0 
mov B.4, C 

mov 73h, B

//Calculating for 74h
mov A, 71h	// Acc gets value of reg 71h: xxxxb3b2b1b0
anl A, #0Fh // Getting lower 4 bits and making other bits 0
mov B, A  	// B = 0000_b3b2b1b0 
SWAP A		// A = b3b2b1b0_0000
add A, B 	// A = b3b2b1b0_b3b2b1b0
mov R3, A
RL A
mov R4, A
RL A 
XRL A,R3
XRL A,R4

mov C, ACC.3 
mov B.6, C 
mov C, ACC.1 
mov B.5, C 
mov C, ACC.0 
mov B.4, C 

mov 74h, B

//Calculating for 75h
mov A, 71h	// A gets value of reg 71h: b3b2b1b0xxxx
anl A, #0F0h // Getting upper 4 bits and making other bits 0
mov B, A    // B = b3b2b1b0_0000
SWAP A   	// A = 0000_b3b2b1b0
mov R5, A	// R5 = 0000_b3b2b1b0
add A, B 	// A = b3b2b1b0_b3b2b1b0
mov R3, A
RL A
mov R4, A
RL A 
XRL A,R3
XRL A,R4

mov B, R5
mov C, ACC.3 
mov B.6, C 
mov C, ACC.1 
mov B.5, C 
mov C, ACC.0 
mov B.4, C 
mov 75h, B

here: sjmp here
end
