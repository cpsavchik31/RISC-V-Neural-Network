.import ../../src/write_matrix.s
.import ../../src/utils.s

.data
m0: .word 1, 2, 3, 4, 5, 6, 7, 8, 9 # MAKE CHANGES HERE TO TEST DIFFERENT MATRICES
file_path: .asciiz "outputs/test_write_matrix/student_write_outputs.bin"

.text
main:
    addi sp sp -4
    sw ra 0(sp)
    # Write the matrix to a file
    la a0, file_path
    la a1, m0
    li a2, 3 #can change
    li a3, 3 
    jal write_matrix
    #   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
    lw ra 0(sp)
    addi sp sp 4
    jal exit
    # Exit the program




   