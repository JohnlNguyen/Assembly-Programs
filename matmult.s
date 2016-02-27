/*
int** matMult(int **a, int num_rows_a, int num_cols_a, int** b, int num_rows_b, int num_cols_b){

  int** c = (int**) malloc((num_rows_a * num_cols_b) * size(int*));
  for(int i = 0; i < num_rows_a*num_cols_b; i++)
    c[i] = (int*) malloc((num_rows_a * num_cols_b) * size(int*));

	for(int i = 0; i < num_rows_a; i++)
		for(int j = 0; j < num_cols_b; j++){
			int sum = 0;
			for(int k = 0; k < num_rows_a; k++){
				c[i][j] += a[i][k] * b[k][j];
			}
		}
	}
    return c;
}
*/

.global matMult

.equ wordsize, 4

.text

matMult:

#prologue

push %ebp
movl %esp, %ebp
subl $5*wordsize, %esp #make space for locals
push %ebx
push %edi

#making space
.equ a, (2*wordsize) #(%ebp)
.equ num_rows_a, (3*wordsize) #(%ebp)
.equ num_cols_a, (4*wordsize) #(%ebp)

.equ b, (5*wordsize) #(%ebp)
.equ num_rows_b, (6*wordsize) #(%ebp)
.equ num_cols_b, (7*wordsize) #(%ebp)
#local variables
.equ c, (-1*wordsize) #(%ebp)
.equ i, (-2*wordsize) #(%ebp)
.equ j, (-3*wordsize) #(%ebp)
.equ k, (-4*wordsize) #(%ebp)
.equ sum, (-5*wordsize) #(%ebp)


#eax is matc
#edi is i/temp
#ebx is temp
#int** c = (int**) malloc((num_rows_a * size(int*);
movl num_rows_a(%ebp), %eax #eax = mat_rows_a
shll $2, %eax #eax = num_rows_a * size(int*)
push %eax
call malloc
addl $1*wordsize, %esp #clear argument
#Save C
movl %eax, c(%ebp)


#for(int i = 0; i < num_rows_a; i++)
#edi = i
#ebx = c
#eax = num_cols_b
#c[i] = (int*) malloc(num_cols_b * size(int*))
movl c(%ebp), %ebx
movl $0, %edi # i = 0
intialized_loop:
movl num_cols_b(%ebp), %eax
shll $2, %eax
push %eax
call malloc
movl  %eax, (%ebx, %edi, wordsize)
incl %edi
cmp num_rows_a(%ebp), %edi
jl intialized_loop

addl $1*wordsize, %esp #clear eax from intialized loop

/*for(int i = 0; i < num_rows_a; i++)
		for(int j = 0; j < num_cols_b; j++){
		for(int k = 0; k < num_cols_a; k++){
					c[i][j] += a[i][k] * b[k][j];*/
movl $0, i(%ebp)
first_loop:
	movl $0, j(%ebp)
		second_loop:
				movl $0, sum(%ebp) #int sum = 0
				movl $0, k(%ebp) #edi = k
				third_loop:
					movl k(%ebp), %edi
					cmpl num_cols_a(%ebp), %edi
					jge end_third_loop
					#a[i][k]
					movl 	a(%ebp), %ebx
					movl 	i(%ebp), %edi
					movl 	(%ebx,%edi, wordsize), %ebx
					movl 	k(%ebp), %edi
					movl 	(%ebx, %edi, wordsize), %eax
					# b[k][j]
					movl 	b(%ebp), %ebx
					movl 	k(%ebp), %edi
					movl 	(%ebx, %edi, wordsize), %ebx
					movl 	j(%ebp), %edi
					movl 	(%ebx, %edi, wordsize), %edx

					#eax += a[i][k] * b[k][j]
					mul %edx
					addl %eax, sum(%ebp)

					incl k(%ebp)
					jmp third_loop
				end_third_loop:

				mov 	sum(%ebp), %edx #edx = sum
				mov 	c(%ebp), %eax   #ebx = C
				mov 	i(%ebp), %edi
				mov 	(%eax, %edi, wordsize), %eax
				mov 	j(%ebp), %edi
				mov 	%edx, (%eax, %edi, wordsize)
				movl 	c(%ebp), %eax #save C to eax

			incl j(%ebp)
			movl j(%ebp), %edx #edx = j
			cmpl num_cols_b(%ebp), %edx
			jge end_second_loop
			jmp second_loop
		end_second_loop:

	incl i(%ebp)
	movl i(%ebp), %ecx #ecx = i
	cmpl num_rows_a(%ebp), %ecx
	jge end_first_loop
	jmp first_loop
end_first_loop:

#epilogue
pop %edi
pop %ebx
movl %ebp, %esp
pop %ebp
ret
