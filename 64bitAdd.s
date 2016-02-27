
.data
#Labels num1 and num2 with 2 elements in each one
num1:
	.long -1  #make space for 32  bits
	.long -1  #make space for 32  bits 

num2: 
	.long -1  #make space for 32 bits
	.long -1  #make space for 32 bits 

sum: 	
	.long 0
	.long 0  	
.text  #Begins the program 

.global _start 

_start: #main of C 
#EBX will hold upper 32
#ECX will hold lower 32
#EDX holds upper 32 bits of sum 
#EAX holds lower 32 bits of sum 

movl num1+4, %eax 		#store lower of num1 to sum
addl num2+4, %eax  		#lower sum and the lower of num2

jnc  No_Carry
	movl $1, %EDX 		#Add 1 if there is a carry 

No_Carry:   			#move here if there is no 1 carries over
	addl num1 ,%edx 	#store upper of num1 to sum
	addl num2, %edx  	#add the upper sum and upper of num1
  

done:
 	movl %eax, %eax   
     
