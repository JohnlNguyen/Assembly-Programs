.global get_combs
.equ wordsize, 4
.text
get_combs:
	#prologue
	push %ebp
	movl %esp, %ebp
	subl $4*wordsize, %esp #make space for locals

	# arguments
	.equ items, 	(2*wordsize) #pointer
	.equ k, 		(3*wordsize) #(%ebp)
	.equ len, 		(4*wordsize) #(%ebp)

	# locals
	.equ counter,   (-1*wordsize) #(%ebp)
	.equ temp,  	(-2*wordsize) #(%ebp)
	.equ numCombs,  (-3*wordsize) #(%ebp)
	.equ main, 	(-4*wordsize) #(%ebp)


	# int counter = 0;
	movl $0, counter(%ebp)

	# int numCombs = num_combs(len, k);
	push k(%ebp)
	push len(%ebp)
	call num_combs
	addl $2*wordsize, %esp    # clear argument
	movl %eax, numCombs(%ebp) # save result

	# int temp[k];
	movl k(%ebp), %edi # edi = k
	shll $2, %edi
	push %edi
	call malloc
	addl $1*wordsize, %esp
	movl %eax, temp(%ebp)


	# int ** main = malloc(sizeof(int *) * numCombs);
	movl numCombs(%ebp), %eax #eax = num_combs
	shll $2, %eax #eax = num_combs * 8
	push %eax
	call malloc
	addl $1*wordsize, %esp #clear argument
	#Save main
	movl %eax, main(%ebp)

	#for (int i = 0; i < numCombs; i++)
	movl main(%ebp), %ebx
	movl $0, %edi # i = 0
	initialized_loop:
		movl k(%ebp), %eax
		shll $2, %eax
		push %eax
		call malloc
		movl k(%ebp), %esi
		movl %eax, (%ebx, %edi, wordsize) #main[i] = malloc(sizeof(int) * k);
		incl %edi
		cmp numCombs(%ebp), %edi
	jl initialized_loop

	#comb_helper(0, 0, len, k, p_counter, temp, main, items);
	push items(%ebp)
	movl main(%ebp), %eax
	push %eax
	push temp(%ebp)
	leal counter(%ebp) , %eax
	push %eax
	push k(%ebp)
	push len(%ebp)
	push $0
	push $0
	call comb_helper
	addl $8*wordsize, %esp  #clear arguments

	#epilogue
	movl main(%ebp), %eax 	# return saved value
	movl %ebp, %esp
	pop %ebp
	ret

comb_helper:
	#prologue
	push %ebp
	movl %esp, %ebp
	subl $1*wordsize, %esp

	# arguments
	.equ num, 	(2*wordsize) #(%ebp)
	.equ select, 	(3*wordsize) #(%ebp)
	.equ max, 	(4*wordsize) #(%ebp)
	.equ maxSelect, (5*wordsize) #(%ebp)
	.equ counter,   (6*wordsize) #(%ebp)
	.equ share, 	(7*wordsize) #(%ebp)
	.equ main, 	(8*wordsize) #(%ebp)
	.equ items2, 	(9*wordsize) #(%ebp)

	# locals
	.equ i,  	(-1*wordsize) #(%ebp)

	#if (select == maxSelect)
	movl maxSelect(%ebp), %edi
	cmpl select(%ebp), %edi
	jnz before_for_loop2 #if false

	#for (i = 0; i < maxSelect; i++)
	movl $0, i(%ebp)
	for_loop1:
		movl i(%ebp), %edi
		cmpl maxSelect(%ebp), %edi
		jge end_for_loop1

		#main[*counter][i] = share[i]
		#share[i]
		movl share(%ebp), %ecx
		movl (%ecx,%edi,wordsize), %ecx #ecx = share[i]

		#main[*counter]
		movl counter(%ebp), %esi #esi = &counter
		movl (%esi), %esi #dereference position @ counter
		movl main(%ebp), %eax # eax = **main
		movl (%eax, %esi, wordsize), %eax #main[*counter]
		movl %ecx, (%eax, %edi, wordsize)  #main[counter][i] = share[i]

		incl i(%ebp) #i++
		jmp for_loop1

	end_for_loop1:
	#(*counter)++;
	movl counter(%ebp), %esi 	 #esi = &counter
	movl (%esi), %esi	 	 #dereference position @ counter
	incl %esi 	  		 #counter++
	movl counter(%ebp), %eax
	movl %esi, (%eax)
	jmp epilogue

	#for (i = num; i < max; i++) #otherwise do the second loop
	before_for_loop2:
		movl num(%ebp), %edi
		movl %edi, i(%ebp) #i = num;
	for_loop2:
		movl i(%ebp), %edi
		cmpl max(%ebp), %edi
		jge end_for_loop2

		#share[select] = items2[i];
		movl items2(%ebp), %ebx
		movl (%ebx, %edi,wordsize), %ecx #ecx = items2[i]
		movl share(%ebp), %eax
		movl select(%ebp), %esi
		movl %ecx, (%eax,%esi,wordsize)

		#comb_helper(i + 1, select + 1, max, maxSelect, counter, share, main, items2);
		#*items2
		push items2(%ebp)

		#main
		movl main(%ebp), %eax
		push %eax

		#share
		push share(%ebp)

		#counter
		push counter(%ebp)

		#maxSelect
		push maxSelect(%ebp)

		#max
		push max(%ebp)

		#select + 1
		movl select(%ebp), %eax
		incl %eax
		push %eax

		#i + 1
		movl i(%ebp), %edi
		incl %edi
		push %edi

		call comb_helper
		addl $8*wordsize, %esp #clear arguments
		#movl main(%ebp), %eax

		incl i(%ebp) #i++
		jmp for_loop2
	end_for_loop2:

	epilogue:
		movl main(%ebp), %eax
		movl %ebp, %esp
		pop %ebp
		ret
