.globl relu

.text
# ==============================================================================
# FUNCTION: Performs an inplace element-wise ReLU on an array of ints
# Arguments:
# 	a0 (int*) is the pointer to the array
#	a1 (int)  is the # of elements in the array
# Returns:
#	None
#
# If the length of the vector is less than 1, 
# this function exits with error code 8.
# ==============================================================================
relu:
    # Prologue
    #is there a need to store a0 and a1 if we are not returing anything?
    addi t0, x0, 1
    blt a1, t0, exit8 #error code 8
    addi sp, sp, -24 # Make space for 3 words on the stack
    sw ra, 0(sp) # Store the return address
    sw a0, 4(sp) # Store register s0
    sw a1, 8(sp) 
    sw s0, 12(sp)
    sw s1, 16(sp)
    sw s2, 20(sp)
    add s1, x0, a0 #put address in t1
    add s2, x0, a1 #length 
    addi t0, x0, 0 #byte incrementer 
loop_start:
    beq t0, s2, loop_end
    #access ith integer, int = 4 bytes 
    lw s0, 0(s1) #put current array val in s0
    blt s0, x0, loop_continue #relu function
    addi s1, s1, 4 #increment address
    addi t0, t0, 1 #increment element counter
    jal x0, loop_start
loop_continue:
    sw x0, 0(s1) #change value in actual array 
    addi s1, s1, 4 #increment address
    addi t0, t0, 1 #increment element counter
    jal x0, loop_start
loop_end:
    lw ra, 0(sp) # Store the return address
    lw a0, 4(sp) # Store register s
    lw a1, 8(sp)
    lw s0, 12(sp)
    lw s1, 16(sp)
    lw s2, 20(sp)
    addi sp, sp, 24
    ret
exit8:
    li a1, 8
    j exit2