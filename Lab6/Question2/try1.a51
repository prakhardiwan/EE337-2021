LED EQU P1.7
	
;ORG 000BH
	;ACALL Timer0_interrupt	
	;RETI
NAME    Timer_subroutines

?PR?timer_init?TIMER_INIT    SEGMENT CODE
        PUBLIC  timer_init
        RSEG    ?PR?timer_init?TIMER_INIT
		;USING register bank 2	
timer_init: MOV TMOD,#0x11
			SETB PSW.4
			;MOV TCON,#0x01
			SETB ET0
			SETB ET1
			mov 81h,#0efh
			mov 82h,#0b9h
			mov 83h,#0f1h
			mov 84h,#88h
			MOV R0,#81H
			MOV R1,#83H
			MOV TH0,@R0
			MOV TH1,@R1
			INC R0
			INC R1
			MOV TL0,@R0
			MOV TL1,@R1
			CLR PSW.4
			SETB EA
			SETB TR0
			SETB TR1
			RET	 
END