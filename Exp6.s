;Jonathan Roa
;Freddy Nunez
;jonathan.roa.730@my.csun.edu
;freddy.nunez.243@my.csun.edu
			
						;0xFF00 puts 1 at pins 8-15 (turns off - negative logic)
						;0x0	puts 0 at pins 8-15 (turns on)
						;5500	alternates the lights
off_mask	EQU			0xBF00			;put value of whatever lights to turn on
all_on_msk	EQU			0xFF00
on_mask		EQU			0xF00
pin_dir		EQU			0xBF00
PINSEL0		EQU			0xE002C000
IO0_BASE	EQU			0xE0028000
DELAY		EQU			3000000
;------------------------------------
;USING IO0BASE, these are offsets to other memory addresses
IO0PIN		EQU			0
IO0DIR		EQU			0x8
IO0SET		EQU			0x4
IO0CLR		EQU			0xC
;can use pre-index addressing with these
;------------------------------------
			GLOBAL		Exp_6
			AREA		Experiment_6, CODE, READONLY
			ENTRY
Exp_6
			LDR r0, =0x3
			LDR	r1, =0x3
			CMP r0, r1
			;EORS r0, r15, r3, ROR r6
			LDR r1, =PINSEL0
			STR r0, [r1] ;register is shotgunned 
			; makes pins 8-15 to be GPIO
			;-----------------------------
			
			MOV	r2, #pin_dir	  ;makes pin 14 as button input, rest as outputs
			LDR r3, =IO0_BASE
			STR	r2, [r3, #IO0DIR] ;pins 11-15 are inputs, 8-11 outputs
			
lights_off	ORR	r0, r0, #off_mask	;lights initially off
			STR	r0, [r3]

if_pressed	
			LDR	r0, [r3]
			TST r0, #0x4000 ;checks if button was pressed
		  LDREQ r5, =0x4000 ;Bit 14 ON mask
		  ORREQ r2, r2, r5 ;value to turn all pins into outputs
		  STREQ	r2, [r3, #IO0DIR] ;everything is an output now
		  BICEQ r0, r0, #all_on_msk	;turns LEDs 8-15 on when button is pressed
		  STREQ	r0, [r3]
			B		if_pressed

;lights_off	ORR	r0, r0, #off_mask	;lights initially off
;			STR	r0, [r3]

;if_pressed	
;			LDR	r0, [r3]
;			TST r0, #0x4000
;		  BICEQ r0, r0, #on_mask	;turns LEDs 8-15 on when button is pressed
;		  STREQ	r0, [r3]
;			B		if_pressed
	
stop		B		stop
;			IMPORT task2
			END