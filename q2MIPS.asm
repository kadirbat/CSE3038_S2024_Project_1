.data
.align 2
array: .space 1024
prompt: .asciiz "Enter integers: "
input_buf: .space 200

.text

main:
    # prompt
    li $v0, 4
    la $a0, prompt
    syscall
    
    # read string
    li $v0, 8
    la $a0, input_buf
    li $a1, 200
    syscall
    
    # parse string
    la $t0, input_buf # get addresses
    la $t1, array
    add $t2, $zero, $zero # current integer
    add $t3, $zero, $zero # check if more than a digit
    add $t5, $zero, $zero # count length
    
string_loop:
    # load char
    lb $t4, 0($t0)
    beq $t4, $zero, end_string
    beq $t4, 10, end_string
    # if encountered a space move on
    beq $t4, 32, next_int
    addi $t3, $zero, 1
    
    # convert ascii to integer
    addi $t4, $t4, -48
    mul $t2, $t2, 10
    add $t2, $t2, $t4
    # get next char
    addi $t0, $t0, 1
    j string_loop
    
next_int:
    # store int
    sw $t2, 0($t1)
    addi $t5, $t5, 1 
    addi $t1, $t1, 4
    # reset check and integer
    add $t2, $zero, $zero
    add $t3, $zero, $zero
    # get next char
    addi $t0, $t0, 1
    j string_loop
    
end_string:
    # store last int
    sw $t2, 0($t1)
    addi $t5, $t5, 1

 
   # algorithm
   la $a0, array
   move $a1, $t5 # length
   jal replace_elements

print:
    la $t1, array   # base
    li $t2, 0       
    
print_loop:
    lw $a0, 0($t1)   
    li $v0, 1 # print int
    syscall
    li $v0, 11
    la $a0, 32       # space
    syscall
    addi $t1, $t1, 4      
    addi $t2, $t2, 1        
    blt $t2, $t6, print_loop # end of array if less than length
    li $v0, 10              # exit program
    syscall

replace_elements:
    # replace when not coprime
    addi $t4, $zero, 1 # check if replacement occurerd
    add $t6, $a1, $zero # temp length that will be subtracted
    
    # array address is in a0, length is in a1
    
    # check temp length 
    add $s0, $zero, $zero
    
check_loop:
    # length -1
    beq $t4, $zero, exit_replacement
    move $t4, $zero # reset check
    move $t0, $zero # loop iterator
    
inner_loop:
    # if i >= length - 1 exit
    addi $s0, $t6, -1
    bge $t0, $s0, check_loop
    
    # get elements at position i and i + 1 (address is in s3, s4)
    mul $s3, $t0, 4 # offset (i * sizeofint)
    add $s3, $s3, $a0
    lw $s1, ($s3) # load first int
    
    addi $s5, $t0, 1 # (i+1)*size
    mul $s4, $s5, 4
    add $s4, $s4, $a0
    lw $s2, ($s4) # load second int
    
    # calculate GCD
    jal gcd
    
    
    # burdan devam ******************************
    move $t7, $v0 # gcd stored into t7
    beq $t7, 1, compare_next
    
    # calculate least common factor LCF
    lw $s1, ($s3) # load arr[i]
    lw $s2, ($s4) # load arr[i+1]
    mult $s1, $s2
    mflo $v0 # move low result 32bit
    # divide by GCD
    div $v0, $t7
    mflo $v0
    
    # store LCF to arr[i]
    sw $v0, ($s3)
    
    
    addi $t2, $t0, 1 # loop iterator for shift loop j
    mul $s7, $t2, 4 # offset (j * sizeofint)
    add $s7, $s7, $a0
    
    move $t1, $s7 # base address of current arr[j]
    blt $t2, $s0, shift_loop
    j update_length
     
shift_loop:
    addi $t1, $t1, 4 # next element
    lw $t3, ($t1)
    sw $t3, -4($t1)
    addi $t2, $t2, 1
    blt $t2, $s0, shift_loop
    j update_length
    
update_length:
    # decrement length
    addi $t6, $t6, -1
    # changed flag reset to 1
    addi $t4, $zero, 1
    # addi $t0, $t0, -1
    j inner_loop
    
compare_next:
    addi $t0, $t0, 1
    j inner_loop
        
exit_replacement:
    j print
    
gcd: 
    # get gcd to compare if coprime
    move $t2, $s1 # copy two int
    move $t3, $s2
    # t2 -> num1
    # t3 -> num2
gcd_loop:
    beq $t3, $zero, gcd_end # if num2 is 0
    move $t8, $t3           # copy num2 to $t8 temp
    div $t2, $t3         
    mfhi $t2               
    move $t3, $t2           # copy remainder to num2
    move $t2, $t8           # copy previous num2 to num1
    j gcd_loop                
gcd_end:
    move $v0, $t2
    jr $ra
        
    
