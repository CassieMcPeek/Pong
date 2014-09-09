;-------------------------------------------------------------------------------
; MSP430 Assembler Code Template for use with TI Code Composer Studio
;	Assignment 3 Lesson 7, Control Flow
;	C1C Cassie McPeek
;	ECE 382
;	Capt Trimble
;	T5
;
;
;-------------------------------------------------------------------------------
            .cdecls C,LIST,"msp430.h"       ; Include device header file

;-------------------------------------------------------------------------------
            .text                           ; Assemble into program memory
            .retain                         ; Override ELF conditional linking
                                            ; and retain current section
            .retainrefs                     ; Additionally retain any sections
                                            ; that have references to current
                                            ; section
;-------------------------------------------------------------------------------
RESET       mov.w   #__STACK_END,SP         ; Initialize stackpointer
StopWDT     mov.w   #WDTPW|WDTHOLD,&WDTCTL  ; Stop watchdog timer

;-------------------------------------------------------------------------------
                                            ; Main loop here
;-------------------------------------------------------------------------------
			mov.w	&0x0216, r5				; puts value into register 5
			mov.w   #0x1234, r7				; puts value of 0x1234 in register 7
			cmp		r5, r7					; compares the value in the register to 0x1234
			jnc		greater					; jump if greater by checking if the value in register 5 is greater than 0x1234, then the carry flag will be set

			mov.w	#0x1000, r7
			cmp		r5, r7				; checks if value in r5 is greater than 0x1000 and sets carrry flag
			jnc		plus

			bit		#0x0001, &0x0216		; test least significant bit stored at 0x0216
			jne		odd						; if the LSB is not zero, then it is an odd number
			mov.w	&0x0216, r5
			clrc
			rrc		r5					; rotates the value right
			mov.w	r5, &0x0212			; stores into memory
			jmp		forever					; jump in order to trap the CPU


odd			mov.w	&0x0216, r5
			add		r5, r5
			mov.w	r5, &0x0212		; stores inot memory
			jmp		forever					; jumps to trap CPU again

plus		mov		#0, &0x0202
			add		#0xEEC0, r5				; adds that to register 5
			adc.b	&0x0202		; compares the LSB of SR to the carry bit and then stores it
			jmp		forever					; jump to trap CPU again

greater		mov.w	#20, r6
			mov.w   r6, r7				; begins the addition sequence
ad			dec		r6
			add.w	r6,r7
			tst		r6
			jz		move					; when zero is added, we will jump to move and store the data

			jmp		ad
move		mov.w 	r7, &0x0206				; stores solution into memory
forever		jmp		forever					; traps the CPU

;-------------------------------------------------------------------------------
;           Stack Pointer definition
;-------------------------------------------------------------------------------
            .global __STACK_END
            .sect 	.stack

;-------------------------------------------------------------------------------
;           Interrupt Vectors
;-------------------------------------------------------------------------------
            .sect   ".reset"                ; MSP430 RESET Vector
            .short  RESET
