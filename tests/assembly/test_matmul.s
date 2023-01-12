.import ../../src/matmul.s
.import ../../src/utils.s
.import ../../src/dot.s

# static values for testing
.data
m0: .word 1 2 3 4 5 6 7 8 9
m1: .word 1 2 3 4 5 6 7 8 9
#m0: .word 1 2 3 
#m1: .word 1 2 3
d: .word 0 0 0 0 0 0 0 0 0 # allocate static space for output

.text
main:
    # Load addresses of input matrices (which are in static memory), and set their dimensions
    li s1, 3 #nrows m0 (mxn) (nxk) = (mxk) 
    li s2, 3 #ncols m0
    li s4, 3 #nrows m1
    li s5, 3 #ncols m1
    la s0, m0
    la s3, m1
    
    #allocate space for d
    #calc size of d in bytes  (mxn) (nxk) = (mxk) --> 4 (mxk)
    li t0, 4
    mul t1, s1, s5
    mul t1, t1, t0 #num bytes in d
    mv a0, t1 #prep for malloc call 
    jal malloc
    mv a6, a0 #returns pointer in a0
    mv a0, s0
    mv a3, s3
	mv a1, s1
    mv a2, s2
    mv a4, s4
    mv a5, s5
    # Call matrix multiply, m0 * m1
    jal matmul

    mv a0, a6
    mv a1, s1
    mv a2, s5
    #   a0 is the pointer to the start of the array
#   a1 is the # of rows in the array
#   a2 is the # of columns in the array
    jal print_int_array

    
    # Exit the program
    jal exit