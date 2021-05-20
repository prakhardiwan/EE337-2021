org 0000h
ljmp main
org 100h
main: 
// For testing 

mov 50h, #0Ah //N
mov 51h, #60h //M1
mov 52h, #5ah // M2

mov 60h, #05h
mov 61h, #06h
mov 62h, #07h
mov 63h, #08h
mov 64h, #09h
mov 65h, #0ah
mov 66h, #0bh
mov 67h, #0ch
mov 68h, #0dh
mov 69h, #0eh
mov 6ah, #0fh

mov r2, 50h	// r2 gets value of reg 50h = N
mov r0, 51h			// r3 gets value of reg 51h = location M1
mov r1, 52h			// r4 gets value of reg 52h = location M2

LCALL memcpy

here: sjmp here
memcpy: mov A, r1
clr C
subb A,r0
jc m2lessthanm1
mov A,r2
dec A // (N-1) as Mx+N-1 is loc of last mem
mov r5,A //r5 = N-1
add A, r0 // A = M1 + N-1
mov r0,A  // r0 = M1+N-1
mov A,r5 //  A = N-1
add A,r1 // A = M2 + N-1
mov r1,A // r1 = M2 + N-1 
m2more: mov A, @r0
mov @r1, A
dec r0
dec r1
djnz r2, m2more
ret

m2lessthanm1: mov A, @r0
mov @r1, A
inc r0
inc r1
djnz r2, m2lessthanm1
ret

end
