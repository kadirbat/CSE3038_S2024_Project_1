.data
prompt1: .asciiz "Enter the coefficient a: "
prompt2: .asciiz "Enter the coefficient b: "
prompt3: .asciiz "Please enter first number of the sequence: "
prompt4: .asciiz "Please enter second number of the sequence: "
prompt5: .asciiz "Enter the number you want to calculate (it must be greater than 1): "

.text
main:
    # Print prompt
    li $v0, 4         # syscall code for print string
    la $a0, prompt1    # load address of the prompt string
    syscall
    # Read first coefficient
    li $v0, 5         # syscall code for read integer
    syscall
    move $s0, $v0     # store the first coefficient in $t0

    # Print prompt
    li $v0, 4         # syscall code for print string
    la $a0, prompt2    # load address of the prompt string
    syscall
    # Read second coefficient
    li $v0, 5         # syscall code for read integer
    syscall
    move $s1, $v0     # store the second coefficient in $t1
    
    
    li $v0, 4         # syscall code for print string
    la $a0, prompt3    # load address of the prompt string
    syscall
 
    li $v0, 5         # syscall code for read integer
    syscall
    move $s2, $v0
    
    li $v0, 4         # syscall code for print string
    la $a0, prompt4   # load address of the prompt string
    syscall
    
    li $v0, 5         # syscall code for read integer
    syscall
    move $s3, $v0
    
    li $v0, 4         # syscall code for print string
    la $a0, prompt5    # load address of the prompt string
    syscall
	
    li $v0, 5         # syscall code for read integer
    syscall
    move $s4, $v0
    # Here you can perform further operations with the coefficients
    
    # Exit program
    li $v0, 10        # syscall code for exit
    syscall
