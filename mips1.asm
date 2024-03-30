.data
prompt: .asciiz "Enter the coefficients: "
coefficients: .space 8  # space for two 32-bit integers

.text
main:
    # Print prompt
    li $v0, 4         # syscall code for print string
    la $a0, prompt    # load address of the prompt string
    syscall

    # Read first coefficient
    li $v0, 5         # syscall code for read integer
    syscall
    move $t0, $v0     # store the first coefficient in $t0

    # Read second coefficient
    li $v0, 5         # syscall code for read integer
    syscall
    move $t1, $v0     # store the second coefficient in $t1

    # Here you can perform further operations with the coefficients
    
    # Exit program
    li $v0, 10        # syscall code for exit
    syscall

