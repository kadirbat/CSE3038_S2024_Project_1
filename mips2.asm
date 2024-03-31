.data
prompt1: .asciiz "Enter the number of elements: "
promptElement: .asciiz "Enter element "
.text
main:
    # print
    li $v0, 4  # mode 4 for printing string
    la $a0, prompt1    
    syscall
    # read a
    li $v0, 5  # mode 5 for getting input
    syscall
    move $s0, $v0 # s0 contains num of elements
    
    add $t0, $zero, $zero # loop counter to create array list
    add $t1, $zero, $zero # head of list
    add $t2, $zero, $zero
    
init_loop:
    bge $t0, $s0, end_init
    li $v0, 4
    la $a0, promptElement
    syscall
    
    # print nth prompt
    move $a0, $t1
    li $v0, 1
    syscall
    li $v0, 4
    la $a0, ": "
    syscall
    
    # read
    li $v0, 5
    syscall
    move $a1, $v0
    
    # allocate mem
    