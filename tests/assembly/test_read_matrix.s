.import ../../src/read_matrix.s
.import ../../src/utils.s

.data
file_path: .asciiz "inputs/test_read_matrix/test_input.bin"
.text
main:
    # Read matrix into memory
    #allocate space of two int pointers
    # void* malloc(int a0)
# Allocates heap memory and return a pointer to it
# args:
#   a0 is the # of bytes to allocate heap memory for
# return:
#   a0 is the pointer to the allocated heap memory
    addi sp, sp, -20
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv s0, a0 #int ptr 1 in s0
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv s1, a0 #int ptr 2 in s1
    la a0, file_path
    mv a1, s0
    mv a2, s1 
    jal read_matrix

    lw a1, 0(s0)
    lw a2, 0(s1)
    jal print_int_array
    # Terminate the program
    #free ptrs, including array created in read_matrix
    mv a0, s0
    jal free
    mv a0, s1
    jal free
    mv a0, s3 
    jal free
    jal t1, preexittr 
    jal exit

    preexittr:
        lw ra, 0(sp)
        lw s0, 4(sp)
        lw s1, 8(sp)
        lw s2, 12(sp)
        lw s3, 16(sp)
        addi sp, sp, 20
        jr t1
    exitcode48:
        jal t1, preexittr
        li a1, 48
        j exit2



   