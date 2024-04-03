.data
InputString: .space 1024         # Reserve space for input string
ShuffleTimes: .word 0            # Memory location for shuffle times
newline: .asciiz "\n"            # Newline character
error_message: .asciiz "length of the input string must be a power of two.\n"   # Error message for invalid input
InputPrompt: .asciiz "Input: "   # Prompt for user input
temp: .space 128                 # Temporary space

.text
.globl main

main:
    # input syscall command
    li $v0, 4
    la $a0, InputPrompt
    syscall

    li $v0, 8
    la $a0, InputString
    li $a1, 1024
    syscall

    la $a0, InputString
    jal removeNewline            # Call function to remove newline character

    # shuffle num
    li $v0, 5
    syscall
    move $t1, $v0               # $t1 = ShuffleTimes
    move $s0, $t1

    # get length
    la $a0, InputString
    jal strlen                   # Link again
    move $t0, $v0               # $t0 = length
    srl $s1, $t0, 1             # Calculate half length
    
    jal isPowerOfTwo
    beq $v0, $zero, error       # Branch to error if not a power of two

    la $a0, InputString
    move $a1, $t0               # $a1 = length
    move $a2, $s0               # $a2 = ShuffleTimes
    move $s2, $a0
    jal swapSubstrings         # Call function to swap substrings

    li $v0, 1
    la $a0, ($a2)               # Display result
    
    li $v0, 4
    la $a0, InputString
    syscall

    # Exit
    li $v0, 10
    syscall

error:
    li $v0, 4
    la $a0, error_message
    syscall

    li $v0, 1
    li $a0, 1
    syscall

# remove newline character from a string
removeNewline:
    move $t0, $a0    
loop:
    lb $t1, 0($t0)    
    beq $t1, $zero, done       # Exit loop if end of string
    beq $t1, '\n', found_newline  # Branch if newline character found
    addi $t0, $t0, 1           # Move to next character
    j loop
found_newline:
    sb $zero, 0($t0)            # Replace newline character with null char
    jr $ra                      # Return

done:
    jr $ra                      # Return

# calc length
strlen:
    move $t0, $zero             # Initialize length
loop_strlen:
    lb $t1, 0($a0)              # Load byte
    beqz $t1, end_strlen        # Exit loop if end of string
    addi $a0, $a0, 1            # Move to next character
    addi $t0, $t0, 1            # Increment length
    j loop_strlen
end_strlen:
    move $v0, $t0               # Return length
    jr $ra

isPowerOfTwo:
    addi $t7, $t0, -1           # n - 1
    and $v0, $t7, $t0           # Bitwise AND
    li $v1, 0                   # Initialize result
    beqz $v0, is_not_power_of_two   # Branch if not a power of two
    j end_isPowerOfTwo
is_not_power_of_two:
    li $v1, 1                   # Set result to indicate not a power of two
end_isPowerOfTwo:
    move $v0, $v1               # Return result
    jr $ra

# algorithm
swapSubstrings:

    addi $sp, $sp, -16          # Allocate space on stack
    sw $ra, 0($sp)              # Save return address
    sw $a0, 4($sp)              # Save base address
    sw $a1, 8($sp)              # Save length
    sw $a2, 12($sp)             # Save shuffle times
    beq $a2, $zero, exit        # If shuffle times is 0, exit
    addi $a2, $a2, -1           # Decrement shuffle times
    srl $a1, $a1, 1             # Calculate midpoint

    # Midpoint
    move $t3, $a1

    li $t4, 0                   # Initialize iterator
    move $t4, $zero             # i=0
    move $t5, $a0               # Substring address
    add  $t6, $t5, $t3          # Substring[mid] address
copy_swap:
    # i < midpoint
    bge $t4, $t3, recursive_call  # Branch if iterator is not less than midpoint

    # Swap substring[i] with substring[mid + i]
    lb $t7, 0($t5)              # Load character at index i
    lb $t8, 0($t6)              # Load character at index mid + i
    sb $t8, 0($t5)              # Store character at index i
    sb $t7, 0($t6)              # Store character at index mid + i

    # Increment iterator and substring addresses
    addi $t4, $t4, 1            # Increment iterator
    addi $t5, $t5, 1            # Increment first half substring address
    addi $t6, $t6, 1            # Increment second half substring address
    j copy_swap                  # Jump back to copy_swap

recursive_call:
    jal swapSubstrings          # Call function recursively for first half
    add $a0, $a0, $t3           # Update base address for second half
    addi $a1, $a1, 1            # Increment length for second half
    jal swapSubstrings          # Call function recursively for second half

exit:
    lw $ra, 0($sp)              # Restore return address
    lw $a0, 4($sp)              # Restore base address
    lw $a1, 8($sp)              # Restore length
    lw $a2, 12($sp)             # Restore shuffle times
    addi $sp, $sp, 16           # Deallocate space on stack
    jr $ra                      # Return
