
.global _start

.data
	dividend:
		.space 4
	divisor:
		.space 4
    counter:
        .long 1
    mask:
        .long 1
	temp:
		.long  0
        .long  0
    quotient:
    	.long 0

.text   #Begins the program
_start:
    #mask in EBX
    #divisor in ECX
    #dividend in EAX
    movl $(1<<31), %ebx  #mask = 1 << (31);
    movl %ebx, mask
    movl divisor, %ecx  #divisor in ECX
    movl dividend, %eax	#dividend in EAX
	movl counter, %edx  #counter in EDX
    movl %eax, temp    #int copy_dend = dividend;
    movl %ecx, temp+4  #int copy_div = divisor;

    #ebx = mask
    #divisor in ECX
    #dividend in EAX
    #counter in EDX
	#temp in ESI
	cmpl %ecx, %eax   # if(divisor > dividend)
    jb end_while	  # skip this while loop
	#while (((divisor & mask) == 0) && ((divisor << 1) <= dividend))
    while:
		movl %ecx, %esi
        andl %ebx, %esi   		#esi = (divisor & mask)
        jnz end_while			#(divisor & mask) - 0) != 0 leave the loop
		shl $1, %ecx 			#divisor <<= 1
        cmpl %ecx,%eax          #dividend - (divisor << 1) >= 0
        jnc end_while           #dividend - (divisor << 1) < 0
        shl $1, %edx
		shl $1, %ecx			#divisor = divisor << 1;
		shl $1, %edx		 	#counter = counter << 1;
        movl %ecx, divisor
        cmpl %ecx,%eax           #dividend - (divisor << 1) >= 0
        jnc end_while            #dividend - (divisor << 1) < 0
		jmp while				 #loop back to the top
	end_while:

    #dividend in EAX
	#quotient in EBX
    #divisor in ECX
    #counter in EDX
	movl %eax, dividend
	movl %edx, counter
    movl divisor, %ecx
    movl $0, %ebx    			#clear ebx for quotient
    #while(counter != 0)
	while2:
		cmpl $0, %edx    			#counter != 0
		jz end_while2
		if:
			cmpl %ecx, %eax			#dividend - divisor >= 0
			jb else					#dividend - divisor < 0
			subl %ecx, %eax         #dividend = dividend - divisor;
            addl %edx, %ebx    #quotient = quotient + counter;
			jmp while2
		else:
			shr $1, %edx		#counter = counter >> 1;
	        shr $1, %ecx		#divisor = counter >> 1;
			jmp while2
		end_while2:
    #ebx has quotient
	movl %ebx, quotient
	#int remainder = dividend - (quotient*divisor);
	movl temp, %ebx   	#ebx = dividend
	movl temp+4, %ecx 	#ecx = divisor
	movl quotient, %eax #eax = quotient
	movl $0, %edx     	#remainder = edx
	imull %ecx 			#eax = quotient*divisor
	subl %eax, %ebx     #ebx = ebx - eax
	movl %ebx, %edx 	#edx now has the remainder
	movl quotient, %eax #eax now has the quotient
done:
	movl %eax, %eax
