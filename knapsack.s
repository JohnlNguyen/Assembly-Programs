.global knapsack
.equ wordsize, 4
.text

max:
	#prologue
	push %ebp
	movl %esp, %ebp

	cmpl %ebx, %eax  #eax - ebx >= 0
	jae epilogue
	movl %ebx, %eax

	epilogue:
   		movl %esp,%ebp
   		pop %ebp
		ret

knapsack:
	#prologue
	push %ebp
	movl %esp, %ebp
	subl $2*wordsize, %esp #make space for locals

	.equ weights, (2*wordsize)
	.equ values, (3*wordsize)
	.equ num_items, (4*wordsize)
	.equ capacity,  (5*wordsize)
	.equ cur_value, (6*wordsize)
	.equ i,			 (-1*wordsize)
	.equ best_value, (-2*wordsize)

	#unsigned int best_value = cur_value;
	movl cur_value(%ebp), %ebx
	movl %ebx, best_value(%ebp)
	#eax edx and ecx cannot have live values

	#edi is i
	#edx is capacity
	#ebx is weights
	movl $0, i(%ebp) # i = 0
	for_loop:
		#i < num_items
		movl i(%ebp), %edi
		cmpl num_items(%ebp), %edi   #i - num_items >= 0
		jae end_for

		if:
			movl capacity(%ebp), %edx
			movl weights(%ebp), %ebx #ebx = weights[i]
			leal (%ebx, %edi, wordsize), %ebx
			cmpl (%ebx), %edx 
			jl else #capacity - weights[i] < 0

			#Calling paramenters in reverse order#

			#cur_value + values[i]
			movl values(%ebp), %eax 	#eax = values
			movl cur_value(%ebp), %ecx #ecx = cur_value
			leal (%eax,%edi,wordsize), %ebx #ebx has values[i]
			addl (%ebx),%ecx #ecx = cur_value + values[i]
			push %ecx

			#capacity - weights[i]
			movl capacity(%ebp), %edx
			movl weights(%ebp), %ebx
			leal (%ebx,%edi,wordsize), %ecx #ecx = weights[i]
			subl (%ecx), %edx #edx = capacity - weights[i]
			push %edx

			#num_items - i - 1
			movl num_items(%ebp), %ebx
			subl %edi, %ebx #ebx = num_items - i - 1
			decl %ebx
			push %ebx

			#int* values + i + 1
			movl values(%ebp), %ebx
			incl %edi
			leal (%ebx,%edi,wordsize), %ecx
			push %ecx

			#int* weights + i + 1
			movl weights(%ebp), %ebx
			leal (%ebx,%edi,wordsize), %ecx
			push %ecx

			call knapsack  #returns eax

			#eax has ret value
			#ebx has best value
			push %eax
			movl best_value(%ebp),%ebx
			push %ebx
			#max(best_value,knapsack)
			call max

			addl $7*wordsize, %esp #clear arguments

			#save best_value
			movl %eax, best_value(%ebp)
	else:
		incl i(%ebp) #i++
		jmp for_loop

	end_for:
		#epilogue
		movl best_value(%ebp), %eax
		movl %ebp, %esp
		pop %ebp
		ret
