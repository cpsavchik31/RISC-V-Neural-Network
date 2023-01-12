.globl argmax

.text
# =================================================================
# FUNCTION: Given a int vector, return the index of the largest
#	element. If there are multiple, return the one
#	with the smallest index.
# Arguments:
# 	a0 (int*) is the pointer to the start of the vector
#	a1 (int)  is the # of elements in the vector
# Returns:
#	a0 (int)  is the first index of the largest element
#
# If the length of the vector is less than 1, 
# this function exits with error code 7.
# =================================================================
argmax:

    # Prologue
    #is there a need to store a0 and a1 if we are not returing anything?
    li t0, 1
    blt a1, t0, exit7 #error code 7
    addi sp, sp, -28 # Make space on the stack
    sw ra, 0(sp) # Store the return address
    sw s0, 4(sp) # Store register s
    sw s1, 8(sp)
    sw s2, 12(sp)
    sw s3, 16(sp)
    sw s4, 20(sp)
    sw s5, 24(sp)
    mv s0, a0 #put address in s0
    mv s1, a1 #total elements
    lw s2, 0(s0) #initialize max
    li s3, -1 #index of max element
    li s5, 0
    li t0, 0 #byte incrementer 
loop_start:
    beq t0, s1, loop_end
    addi s3, s3, 1 #update index to curr
    addi t0, t0, 1 #update incrementer
    lw s4, 0(s0) #access curr element
    addi s0, s0, 4 #increment address
    blt s2, s4, loop_continue
    j loop_start
loop_continue:
    mv s5, s3
    mv s2, s4
    j loop_start
exit7:
    li a1, 7
    j exit2
loop_end:
    mv a0, s5
    lw ra, 0(sp) 
    lw s0, 4(sp) 
    lw s1, 8(sp)
    lw s2, 12(sp)
    lw s3, 16(sp)
    lw s4, 20(sp)
    lw s5, 24(sp)
    addi sp, sp, 28
    ret
  
    