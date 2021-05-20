org 0000h
ljmp main
org 100h
main: mov A, 70h	// Acc gets value of reg 70h
mov r2, 71h			// R2 gets value of reg 71h 
mov 73h, #00h 		// 73h has 0 initially as well but just to make sure. 
add A, r2			// A = A + r2 
mov 72h, A			// 72h gets the result of addition, i.e. the lower 8-bits
jc carry_present    // Jump if carry is 1
here: sjmp here
carry_present: mov 73h, #01h	// 73h getting the value of carry bit
sjmp here 
end
