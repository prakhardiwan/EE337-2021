org 0000h
ljmp main 
org 100h

main:
mov R0, #0a1h  		// lower byte of N 
mov A, R0
cpl A
mov R2, A
mov R1, #10h 			// upper byte of N
mov A, R1
cpl A
mov R1,A
mov A,R2
inc A
jc addone
mov R0,A
here: sjmp here

addone: 
inc R1
ret

end