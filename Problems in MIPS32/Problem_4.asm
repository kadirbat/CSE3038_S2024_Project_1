.data
matrix: .byte 5, 6, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 1, 1, 0, 1, 0, 0,
        1, 1, 0, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 0

output_string: .asciiz "The number of the 1s on the largest island is "
newline: .asciiz "\n"

    .text
    .globl main

main:
    # Load number of rows and columns from memory
    lb $t0, matrix           # Load number of rows
    lb $t1, matrix+1         # Load number of columns

    # Print the matrix
    la $a0, matrix+2         # Load address of the first element of the matrix
    move $a1, $t0            # Load number of rows
    move $a2, $t1            # Load number of columns
    jal print_matrix         # Call print_matrix function

    # Initialize matrix index variables
    li $t2, 0                # Initialize row index
    li $t3, 0                # Initialize column index
    la $t4, matrix+2         # Load address of the first element of the matrix


matrix_traverse_loop:
    # If current row index >= number of rows, exit loop
    bge $t2, $t0, find_largest_island

    # If current column index >= number of columns, go to next row
    bge $t3, $t1, next_row

    # Load matrix element
    lb $t5, 0($t4)

    # Store matrix element in appropriate location
    sw $t5, ($t4)

    # Move to next column
    addi $t3, $t3, 1
    addi $t4, $t4, 4

    j matrix_traverse_loop  # Repeat for next element in the row

next_row:
    # Move to next row
    addi $t2, $t2, 1
    li $t3, 0                # Reset column index to 0

    j matrix_traverse_loop  # Repeat for next row

find_largest_island:
    # Initialize variables for DFS
    li $t0, 0              # row = 0
    li $t1, 0              # column = 0
    move $a0, $t0          # Pass row as argument
    move $a1, $t1          # Pass column as argument
    move $a2, $t2          # Pass rows as argument
    move $a3, $t3          # Pass columns as argument
    jal DFS                # Call DFS function

    # Print the result
    li $v0, 4                   # System call for printing string
    la $a0, output_string       # Load address of output string
    syscall                     # Perform syscall

    move $a0, $v0              # Load maxIslandSize to print
    li $v0, 1                   # System call for printing integer
    syscall                     # Perform syscall

    li $v0, 4                   # System call for printing string
    la $a0, newline             # Load address of newline string
    syscall                     # Perform syscall

    li $v0, 10                  # Exit program
    syscall                     # Perform syscall

DFS:
    # Function to perform depth-first search (DFS) to find the size of the island
    # $a0: row, $a1: column, $a2: rows, $a3: columns

    # Calculate offset for current matrix element
    mul $t4, $a0, $a3         # row * columns
    add $t4, $t4, $a1         # (row * columns) + column
    sll $t4, $t4, 2           # Multiply by 4 to get byte offset
    la $t5, matrix            # Load base address of matrix
    add $t4, $t4, $t5         # Add base address of matrix

    # Load current matrix element
    lb $t6, ($t4)

    # Check if the current cell is valid and has value 1
    beq $t6, $zero, DFS_end   # If matrix[row][column] == 0, return

    # Mark the current cell as visited (set to 0)
    sb $zero, ($t4)

    # Define the four directions: up, down, left, right
    li $t7, -1                # Load -1 to $t7 (for up and left)
    li $t8, 1                 # Load 1 to $t8 (for down and right)

    # Visit all four adjacent cells
    add $a0, $a0, $t7         # Compute newRow (up)
    jal DFS                   # Call DFS function

    add $a0, $a0, $t8         # Compute newRow (down)
    jal DFS                   # Call DFS function

    add $a1, $a1, $t7         # Compute newColumn (left)
    jal DFS                   # Call DFS function

    add $a1, $a1, $t8         # Compute newColumn (right)
    jal DFS                   # Call DFS function

DFS_end:
    jr $ra                    # Return from DFS

print_matrix:
    # Function to print the matrix as a 2D matrix
    # $a0: address of the first element of the matrix, $a1: rows, $a2: columns

    move $s0, $a0            # Save address of the first element
    move $s1, $a1            # Save number of rows
    move $s2, $a2            # Save number of columns
    li $t0, 0                # Initialize row index
    li $t1, 0                # Initialize column index

print_matrix_outer_loop:
    bge $t0, $s1, print_matrix_exit  # If row index >= number of rows, exit loop

    li $t2, 0                # Initialize column counter

print_matrix_inner_loop:
    bge $t2, $s2, print_matrix_newline  # If column counter >= number of columns, print newline and go to next row

    # Load matrix element
    lb $t3, ($s0)

    # Print matrix element
    li $v0, 1                # System call for printing integer
    move $a0, $t3            # Load element to print
    syscall

    # Print space
    li $v0, 11               # System call for printing space
    li $a0, 32               # ASCII code for space
    syscall

    # Move to next element
    addi $s0, $s0, 1         # Move to next element
    addi $t2, $t2, 1         # Increment column counter

    j print_matrix_inner_loop

print_matrix_newline:
    # Print newline
    li $v0, 4                # System call for printing string
    la $a0, newline          # Load address of newline string
    syscall

    # Move to next row
    addi $t0, $t0, 1         # Increment row index
    j print_matrix_outer_loop

print_matrix_exit:
    jr $ra                   # Return from print_matrix
