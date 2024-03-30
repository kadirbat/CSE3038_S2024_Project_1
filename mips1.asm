.data
prompt1: .asciiz "Enter the coefficient a: " #s0
prompt2: .asciiz "Enter the coefficient b: " #s1
prompt3: .asciiz "Please enter first number of the sequence: " #s2
prompt4: .asciiz "Please enter second number of the sequence: " #s3 
prompt5: .asciiz "Enter the number you want to calculate (it must be greater than 1): " #s4
output1: .asciiz "Output: "
output2: .asciiz "th element of the sequence is "

.text
main:
    # print
    li $v0, 4  
    la $a0, prompt1    
    syscall
    # read a
    li $v0, 5    
    syscall
    move $s0, $v0     

    # print prompt
    li $v0, 4        
    la $a0, prompt2 
    syscall
    # read b
    li $v0, 5        
    syscall
    move $s1, $v0    
    
    # read x0
    li $v0, 4        
    la $a0, prompt3   
    syscall
    li $v0, 5        
    syscall
    move $s2, $v0
    
    # read x1
    li $v0, 4      
    la $a0, prompt4   
    syscall
    li $v0, 5      
    syscall
    move $s3, $v0
    
    # read n
    li $v0, 4       
    la $a0, prompt5   
    syscall
    li $v0, 5     
    syscall
    move $s4, $v0
    
func: 

    # when n is 0 or 1 (base case) return
    beq $s4, $zero, L1
    beq $s4, 1, L2
    addi $t0, $zero, 3
    
loop:
    
    # if greater than exit
    bgt $t0, $s4, L3
    mul $t1, $s0, $s3
    mul $t2, $s1, $s2
    add $t1, $t1, $t2
    addi $v1, $t1, -2
    
    move $s2, $s3
    move $s3, $v1
    addi $t0, $t0, 1
    j loop
    
L1: 

   move $v1, $s2
   j L3
   
L2: 
   
   move $v1, $s3
   j L3
   
L3:
   li $v0, 4    
   la $a0, output1 
   syscall
   
   move $a0, $s4     
   li $v0, 1         
   syscall

   li $v0, 4      
   la $a0, output2   
   syscall
   
   li $v0, 5
   # result
   move $a0, $v1      
   li $v0, 1          # print integer
   syscall

   li $v0, 10
   syscall    