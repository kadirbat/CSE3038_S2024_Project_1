.data
prompt: .asciiz "Enter an integer: "
result: .word 0

.text
main:


    # Read integer
    li $v0, 5           # Load immediate (syscall code for read integer)
    syscall             # Read integer
    move $t0, $v0       # Move the read integer value to temporary register $t0

    # Print the integer
    li $v0, 1           # Load immediate (syscall code for print integer)
    move $a0, $t0       # Move the integer value to argument register $a0
    syscall             # Print integer
