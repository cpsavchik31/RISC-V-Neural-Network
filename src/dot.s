.globl dot

.text
# =======================================================
# FUNCTION: Dot product of 2 int vectors
# Arguments:
#   a0 (int*) is the pointer to the start of v0
#   a1 (int*) is the pointer to the start of v1
#   a2 (int)  is the length of the vectors
#   a3 (int)  is the stride of v0
#   a4 (int)  is the stride of v1
# Returns:
#   a0 (int)  is the dot product of v0 and v1
#
# If the length of the vector is less than 1, 
# this function exits with error code 5.
# If the stride of either vector is less than 1,
# this function exits with error code 6.
# =======================================================
#access *(a + i * s), ith element of int* a with stride s
dot:
    # Prologue
    li t0, 1
    blt a2, t0, exit5 
    blt a3, t0, exit6
    blt a4, t0, exit6
    addi sp, sp, -28 # Make space on the stack
    sw ra, 0(sp) # Store the return address
    sw s0, 4(sp) # Store register s
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    mv s0, a0 #put address v1
    mv s1, a1 #put address v2
    mv s2, a2 #tot length
    mv s3, a3 #stride v1
    mv s4, a4 #stride v2
    li t0, 0 #byte incrementer 
    li s5, 0 #dot prod
loop_start:
    beq t0, s2, loop_end
    li t4, 4
    mul t1, t4, s3 #base offset for v1
    mul t2, t4, s4 #base offset for v2
    lw t3, 0(s0) #access ith index of v1 
    lw t4, 0(s1) #access ith index v2
    add s0, s0, t1 #address of v1[i]
    add s1, s1, t2 #address of v2[i]  
    mul t3, t3, t4 #multiply ith elements 
    add s5, s5, t3 #add to accumulating sum of dot prod
    addi t0, t0, 1 #increment counter
    jal x0, loop_start
exit5:
    li a1, 5
    j exit2
exit6:
    li a1, 6
    j exit2
exit7:
    li a7, 7
    j exit2
loop_end:
    mv a0, s5
    lw ra, 0(sp) # Store the return address
    lw s0, 4(sp) # Store register s
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28 # Make space on the stack
    ret








    