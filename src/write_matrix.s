.globl write_matrix

.text
# ==============================================================================
# FUNCTION: Writes a matrix of integers into a binary file
#   If any file operation fails or doesn't write the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes of the file will be two 4 byte ints representing the
#   numbers of rows and columns respectively. Every 4 bytes thereafter is an
#   element of the matrix in row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is the pointer to the start of the matrix in memory
#   a2 (int)   is the number of rows in the matrix
#   a3 (int)   is the number of columns in the matrix
# Returns:
#   None
#
# If you receive an fopen error or eof, 
# this function exits with error code 53.
# If you receive an fwrite error or eof,
# this function exits with error code 54.
# If you receive an fclose error or eof,
# this function exits with error code 55.
# ==============================================================================
write_matrix:
    # Prologue
    addi sp, sp, -48
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    sw s6, 28(sp)
    sw s7, 32(sp)
    sw s8, 36(sp)
    sw s9, 40(sp)
    sw s10, 44(sp)
    mv s0, a0 #file ptr (char*)
    mv s1, a1 #array ptr
    mv s2, a2 # nrows
    mv s3, a3 #ncols
   

    mv a1, s0 #file ptr
    li a2, 1 #write
    jal fopen #a0 file descriptor
    li t0, -1
    beq a0, t0, exitcode53
    mv s4, a0 #file descriptor
    
    #create int ptrs?
    li a0, 8
    jal malloc
    beq a0, x0, exitcode48
    mv s5, a0 #int ptr 
    sw s2, 0(s5)
    sw s3, 4(s5)

    # Writes a3 * a4 bytes from the buffer in a2 to the file descriptor a1.
    # args:
    #   a1 = file descriptor
    #   a2 = Buffer to read from
    #   a3 = Number of items to read from the buffer.
    #   a4 = Size of each item in the buffer.
    # return:
    #   a0 = Number of elements writen. If this is less than a3,
    #    it is either an error or EOF. You will also need to still flush the fd.

    #write first two nums
    mv a1, s4
    mv a2, s5
    li a3, 1
    li a4, 4
    jal fwrite 
    bne a0, a3, exitcode54

    mv a1, s4
    addi a2, s5, 4 
    li a3, 1
    li a4, 4
    jal fwrite 
    bne a0, a3, exitcode54

    lw t0, 0(s5)
    lw t1, 4(s5)
    mul t0, t0, t1
    #write matrix
        mv a1, s4
        mv a2, s1
        mv a3, t0
        li a4, 4
        jal fwrite
        bne a0, a3, exitcode54
        jal t1 preexitw
        ret
    exitcode53:
        jal t1 preexitw
        li a1, 53
        j exit2
    exitcode54:
        jal t1 preexitw
        li a1, 54
        j exit2
    exitcode48:
        jal t1 preexitw
        li a1, 48
        j exit2
    exitcode55:
        jal t1 preexitw
        li a1, 55
        j exit2
        
    preexitw:
        mv a0, s5
        jal free
        mv a0, s6
        jal free
        #flush file for all errors?
        #mv a1, s4
        #jal fflush
        mv a1, s4
        jal fclose
        # return:
        #a0 = 0 on success, and EOF (-1) otherwise.
        #how should this error be handled?
        lw ra, 0(sp)
        lw s0, 4(sp)
        lw s1, 8(sp)
        lw s2, 12(sp)
        lw s3, 16(sp)
        lw s4, 20(sp)
        lw s5, 24(sp)
        lw s6, 28(sp)
        lw s7, 32(sp)
        lw s8, 36(sp)
        lw s9, 40(sp)
        lw s10, 44(sp)
        addi sp, sp, 48
        jr t1
   
