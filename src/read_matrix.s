.globl read_matrix

.text
# ==============================================================================
# FUNCTION: Allocates memory and reads in a binary file as a matrix of integers
#   If any file operation fails or doesn't read the proper number of bytes,
#   exit the program with exit code 1.
# FILE FORMAT:
#   The first 8 bytes are two 4 byte ints representing the # of rows and columns
#   in the matrix. Every 4 bytes afterwards is an element of the matrix in
#   row-major order.
# Arguments:
#   a0 (char*) is the pointer to string representing the filename
#   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
#   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
# Returns:
#   a0 (int*)  is the pointer to the matrix in memory
#
# If you receive an fopen error or eof, 
# this function exits with error code 50.
# If you receive an fread error or eof,
# this function exits with error code 51.
# If you receive an fclose error or eof,
# this function exits with error code 52.
# ==============================================================================
read_matrix:
    # Prologue
	addi sp, sp, -24
    sw ra, 0(sp)
    sw s0, 4(sp)
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    mv s0, a1 #int pointers
    mv s1, a2
    #open file
    mv a1, a0 #fopen takes a1 arg as file pointer
    li a2, 0 #specify read permission
    jal fopen #args: a1, a2; returns: a0, file descriptor --> failure when a0 = -1
    li t0, -1
    beq a0, t0, exitcode50
    mv s2, a0 #s2 holds file descriptor!
    #first 8 bytes of file= two 4 byte matrix dimension values
    #get the first 2 nums
    #call to fread
    mv a1, s2 #file descriptor
    mv a2, s0 #int ptr 1
    li a3, 4 #read first four bytes
    jal fread #returns: a0, # bytes read from file, if
    #num bytes read differs from num bytes specified: either
    #hit EOF or error
    bne a3, a0, exitcode51
    mv s0, a2 #int ptr 1
    mv a2, s1 #int ptr 2 
    jal fread #call fread again to read next 4 bytes
    bne a3, a0, exitcode51
    mv s1, a2 #int ptr 2 
    #create loop to read rest of file
    #allocate mem for matrix, now that we know dimensions
    li s4, 4
    lw t1, 0(s0)
    lw t2, 0(s1)
  

    mul s4, s4, t1
    mul s4, s4, t2 #t0 contains total mem needed for matrix
    #prep for malloc call
    mv a0, s4 #move total bytes to a0
    jal malloc #returns pointer in a0
    beq a0, x0, exitcode48
    #mv s3, a0 #matrix pointer in s3 
    mv a1, s2 #file descriptor
    mv a2, a0 #start of buffer
    mv a3, s4 #tot bytes to read
    jal fread
    bne a0, a3, exitcode51 #rread didnt read specified num bytes
    mv s3, a2
    jal t1 preexitr
    ret
    preexitr:
        mv a1, s2
        jal fflush
        mv a1, s2 #prep for fclose
        jal fclose
        bne a0, x0, exitcode52 #check this part, supposed to return 0,
        mv a0, s3 #put matrix pointer in a0 to return
        mv a1, s0
        mv a2, s1
        lw ra, 0(sp)
        lw s0, 4(sp)
        lw s1, 8(sp)
        lw s2, 12(sp)
        lw s3, 16(sp)
        lw s4, 20(sp)
        addi sp, sp, 24
        jr t1
    exitcode48:
        jal t1, preexitr
        li a1, 48
        j exit2
    exitcode50:
        lw ra, 0(sp)
        lw s0, 4(sp)
        lw s1, 8(sp)
        lw s2, 12(sp)
        lw s3, 16(sp)
        lw s4, 20(sp)
        addi sp, sp, 24
        li a1, 50
        j exit2
    exitcode51:
        jal t1, preexitr
        li a1, 51
        j exit2
    exitcode52:
        lw ra, 0(sp)
        lw s0, 4(sp)
        lw s1, 8(sp)
        lw s2, 12(sp)
        lw s3, 16(sp)
        lw s4, 20(sp)
        addi sp, sp, 24
        li a1, 52
        j exit2
    
