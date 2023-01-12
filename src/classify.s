.globl classify

.text
classify:
    # =====================================
    # COMMAND LINE ARGUMENTS
    # =====================================
    # Args:
    #   a0 (int)    argc
    #   a1 (char**) argv
    #   a2 (int)    print_classification, if this is zero, 
    #               you should print the classification. Otherwise,
    #               this function should not print ANYTHING.
    # Returns:
    #   a0 (int)    Classification
    # 
    # If there are an incorrect number of command line args,
    # this function returns with exit code 49.
    #
    # Usage:
    #   main.s -m -1(argv) <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    #verify number of command lines args, should it be 4 or 5?
    addi t0, x0, 5
    #bne a0, t0, exitcode49
    addi sp, sp, -52
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
    sw s11, 48(sp)
    #mv s0, a2 #command line args in s0, each one is 32 bits?
    #lw s0, 12(a1) #m0 path
    #lw s1, 16(a1) #m1 path
    #lw s2, 20(a1) #input
    #lw s3, 24(a1) #output
    mv s0, a1
    mv s11, a2

    
   
    # void print_str(char *a1)
# Prints the null-terminated string at address a1.
# args:
#   a1 = address of the string you want printed.
# return:
#   void
   
    









	# =====================================
    # LOAD MATRICES (read matrix)
    # =====================================
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is a pointer to an integer, we will set it to the number of rows
    #   a2 (int*)  is a pointer to an integer, we will set it to the number of columns
    # Returns:
    #   a0 (int*)  is the pointer to the matrix in memory
    #a1--> main.s -m -1(argv) <M0_PATH> <M1_PATH> <INPUT_PATH> <OUTPUT_PATH>
    #load pretrained m0
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv s7, a0 #int ptr 1 in s7
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv a2, a0 #int ptr 2 in a2
    mv a1, s7 #int ptr 1
    #lw a0, 4(s0) #m0 path
    lw a0, 12(s0) #m0 path
    jal read_matrix
    mv s1, a1
    mv s2, a2 
    mv s3, a0

    #lw a0, 12(s0)
    #lw a1, 0(s1) #nrows
    #lw a2, 0(s2) #ncols
    #al print_int_array

    lw a1, 16(s0)
    jal print_str

   
    #load pretrained m1
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv s7, a0 #int ptr 1 in a1
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv a2, a0 #int ptr 2 in a2
    mv a1, s7
    #lw a0, 8(s0) #m1 path
    lw a0, 16(s0) #m0 path
    jal read_matrix
    mv s4, a1
    mv s5, a2 
    mv s6, a0

    
    # Load input matrix
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv s7, a0 #int ptr 1 in a1
    li a0, 4
    jal malloc
    beq a0, x0, exitcode48
    mv a2, a0 #int ptr 2 in a2
    mv a1, s7 #int ptr 1
    #lw a0, 12(s0) #input path
    lw a0, 20(s0) 
    jal read_matrix
    mv s7, a1 #nrows
    mv s8, a2
    mv s9, a0

  
    #initialize d= (m0 x input), 
    #dim= (s1 x s8)
    li t0, 4
    lw t1, 0(s1)
    lw t2, 0(s8)
    mul t1, t1, t2
    mul t1, t1, t0 #tot num bytes
    mv a0, t1 #prep for malloc call 
    jal malloc
    mv a6, a0 #returns pointer in a0






    
    # =====================================
    # RUN LAYERS
    # =====================================
    # 1. LINEAR LAYER:    m0 * input
    #lw a0, 4(s0) #pointer to m0
    lw a0, 12(s0) #m0 path
    lw a1, 0(s1) #nrows m0
    lw a2, 0(s2) #ncols m0
    mv a3, s9 #ptr to input
    lw a4, 0(s7)
    lw a5, 0(s8) 
    # void print_int(int a1)
# Prints the integer in a1.
# args:
#   a1 = integer to print
# return:
#   void
    
    


    jal matmul
    mv s9, a6 #pointer to d = m0 * input
    
    

    # 2. NONLINEAR LAYER: ReLU(m0 * input)
    # Arguments:
    # 	a0 (int*) is the pointer to the array
    #	a1 (int)  is the # of elements in the array
    # Returns:
    #	None
    mv a0, s9
    lw t1, 0(s1)
    lw t2, 0(s8)
    mul t1, t1, t2 #tot num elements in d
    mv a1, t1
    jal relu #doesn't return anything, just modifies d
    mv s9, a0



  
    



    #initialize new matrix
    #initialize d'
    #dim= (s4 x s8)
    li t0, 4
    lw t1, 0(s4) #nrows
    lw t2, 0(s8) #ncols
    mul t1, t1, t2
    mul t1, t1, t0 #tot num bytes
    mv a0, t1 #prep for malloc call 
    jal malloc
    mv a6, a0 #returns pointer in a0

    
    # 3. LINEAR LAYER:    m1 * ReLU(m0 * input) --> dim(s4 x s8)
    #lw a0, 8(s0) #pointer to m1
    lw a0, 16(s0) 
    lw a1, 0(s4) #rows
    lw a2, 0(s5) #cols
    addi a3, s9, 0 
    lw a4, 0(s1) #rows #CHECK   
    lw a5, 0(s8) #cols 
    jal matmul
    mv s10, a6 #d' in s10
    
   


    # =====================================
    # WRITE OUTPUT
    # =====================================
    # Write output matrix
    # Arguments:
    #   a0 (char*) is the pointer to string representing the filename
    #   a1 (int*)  is the pointer to the start of the matrix in memory
    #   a2 (int)   is the number of rows in the matrix
    #   a3 (int)   is the number of columns in the matrix
    # Returns:
    #   None
    lw a0, 24(s0) #file ptr from argv
    #lw a0, 16(s0) #m0 path
    mv a1, s10 #pointer to d'
    lw a2, 0(s4) #nrows
    lw a3, 0(s8) #ncols
    #   a0 is the pointer to the start of the array
#   a1 is the # of rows in the array
#   a2 is the # of columns in the array
  

    jal write_matrix

    #Once you’ve obtained the scores, we expect you to save them to the output file passed in on the
    #command line. Then, call argmax, which will return a single integer representing the classification
    #for your input, and print it.
    #Note that when calling argmax and relu, you should treat your inputs as 1D arrays. That means
    #the length you pass into the function should be the number of elements in your entire matrix.

    # =====================================
    # CALCULATE CLASSIFICATION/LABEL
    # =====================================
    # Call argmax
    #d' in s10 has dim (s4xs8)
        mv a0, s10
        lw t1, 0(s4)
        lw t2, 0(s8)
        mul a1, t1, t2 #tot num elements
        jal argmax
        beq s11, x0, print_classification
        jal t1, preexiter
        ret
      #free all memory
     
    #restore stack
    preexiter:
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
        lw s11, 48(sp)
        addi sp, sp, 52
        jr t1

    exitcode48:
        jal t1 preexiter
        li a1, 48
        j exit2
    exitcode49:
        jal t1 preexiter
        li a1, 49
        j exit2

    print_classification:
        	mv a1, a0 
        	jal print_int
    # Print newline afterwards for clarity
        	li a1, '\n'
        	jal print_char
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
            lw s11, 48(sp)
            addi sp, sp, 52
            ret 
    