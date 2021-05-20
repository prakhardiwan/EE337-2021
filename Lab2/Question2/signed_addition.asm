org 0000h
ljmp main
org 100h
main: 
//Testing
mov 60h, #7fh
mov 61h, #7eh

mov A, 60h	// Acc gets value of reg 60h
mov r2, 61h			// R2 gets value of reg 61h 
add A, r2			// A = A + r2 

mov 62h, A			// 62h gets the result of addition, i.e. the lower 8-bits
jb PSW.2, overflow_present    // Jump if overflow is 1
setb PSW.5 
here: sjmp here
overflow_present: 
clr PSW.5	// setting it to 0 as invalid value
sjmp here 
end
