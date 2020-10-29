/*
	Author: Jeremy Kimotho
	Date: 29/10/2020
*/	
	.text		//code section. Read only section
	prnfmt1: .string "\n***** Program Starts *****\n"
	prnfmt2: .string "%d * %d = %d\n"
	prnfmt3: .string "***** Program Ends *****\n\n"	

	// Defined Macros
	define(Initial_I,x20)
	define(Random_I,x22)
	define(Sum, x26)	
	define(Multiplier, x23)
	define(Multiplicand, x27)
	define(Counter, x24)
	define(Intermediate, x25)

	.balign 4
	.global main 

main:
	stp	x29,	x30,	[sp, -16]!		// save fp register and link register current values
	mov	x29,	sp				// update fp register
	ldr	x0,	=prnfmt1			// loads register x0 with address of beginning string
	bl	printf					// branch call to the c function printf which will print our program begins message

	 	
	mov	Initial_I,	-15			// copying -15 to the register x20
	mov	x0,	xzr				// xzr which is 0 is copied  to the x0 register to seed our random
	bl	time					// branch call to the c function time which along with srand seeds our rand
	bl	srand					// branch call to the c function srand which along with time seeds our rand  
loop:							// the label name for our loop which generates our random integer
	bl 	rand					// branch call to the c function rand which returns for a random integer larger than 0
	mov	x1,	0xF				// copies the hexadecimal value 15 to register x1
	and	x2,	x0,	x1			// takes the and of x0 and x1 which bit masks and ensures our number is kept 15 or under. copies result into x2
	mov	Random_I,	x2			// copies the value in x2 to the x22 register called Random_I
	cmp	Random_I,	+15			// compares the random number we generated to 15
	b.gt	loop					// branch back to the start of our loop if the random number we generated is larger than 15
	
	mov	Counter,	0			// initialise the register x24 which is our counter with 0
	mov	Multiplier,	Random_I		// copy the random integer we generated into register x23 which will be the multiplier  
	mov	Multiplicand,	Initial_I		// copy  the integer [-15,15] into register x27 which will be our multiplicand
	mov	Sum,		0			// initialise the register x26 which is our sum with 0

loop1:							// label name for the loop which does the shifting multiplication
	ands	Intermediate,	Multiplier,	1	// takes the and of multiplier and 1 and sets z flag
	b.eq	incrementing				// if z flag has been set we branch to incrementing
	add	Sum,	Sum,	Multiplicand		// adds the multiplicand to the sum and puts that result back  into the sum
incrementing:						// where we do the shifting of multiplier and multiplicand and  increment counter
	lsl	Multiplicand,	Multiplicand,	1	// logical shift left the multiplicand
	asr	Multiplier,	Multiplier,	1	// arithmetic shift right the multiplier (we use instead of lsr to preserve the sign)
	add	Counter,	Counter,	1	// increment counter by 1
	cmp	Counter,	64			// compare our counter to 64
	b.lt	loop1					// if counter is less than 64 we branch back to the start of shifting loop
		
printReturn:						// label name for the function where we print out the multiplication result
	ldr	x0,	=prnfmt2			// loads register x0 with address of string message to display to the user
	mov	x1,	Initial_I			// copies the integer between -15 to 15 to x1 for printing
	mov	x2,	Random_I			// copies our random integer to x2 for printing
	mov	x3,	Sum				// copies the result of the multiplication to  the register x3 for printing
	bl	printf					// branch call to the c function printf which will print our multiplication result
	add	Initial_I, Initial_I, 1			// increment x20 which is the integer between -15 and 15
test:							// label name for the function where we test if we've multiplied till +16  yet
	cmp	Initial_I, +16				// compares our initial integer in register x20 with signed integer 16 	
	b.lt	loop					// branch back to the start of the loop if we haven't reached 15 yet

end:							// label name for the function where we print out the program ended message and restore registers
	ldr	x0,	=prnfmt3			// loads register x0 with string address of ending string
	bl	printf					// branch call to the c function printf which will print our program ends message
	ldp	x29,	x30,	[sp], 16		// restore fp and link registers 
	ret

	// data section contains initialised global variables
	.data 		

