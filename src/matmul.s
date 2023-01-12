.globl matmul

.text
# =======================================================
# FUNCTION: Matrix Multiplication of 2 integer matrices
# 	d = matmul(m0, m1)
#   The order of error codes (checked from top to bottom):
#   If the dimensions of m0 do not make sense, 
#   this function exits with exit code 2.
#   If the dimensions of m1 do not make sense, 
#   this function exits with exit code 3.
#   If the dimensions don't match, 
#   this function exits with exit code 4.
# Arguments:
# 	a0 (int*)  is the pointer to the start of m0 
#	a1 (int)   is the # of rows (height) of m0
#	a2 (int)   is the # of columns (width) of m0
#	a3 (int*)  is the pointer to the start of m1
# 	a4 (int)   is the # of rows (height) of m1
#	a5 (int)   is the # of columns (width) of m1
#	a6 (int*)  is the pointer to the the start of d
# Returns:
#	None (void), sets d = matmul(m0, m1)
# =======================================================
matmul:
    addi t0, x0, 1
    # Error checks
    blt a1, t0, ex2
    blt a2, t0, ex2
    blt a3, t0, exit3
    blt a4, t0, exit3
    bne a2, a4, exit4
    # Prologue
    addi sp, sp, -48 # Make space on the stack
    sw ra, 0(sp) # Store the return address
    sw s0, 4(sp) # Store register s
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
    mv s0, a0 #put address m0 (mxn)
    mv s1, a1 #m0,m
    mv s2, a2 #m0,n
    mv s3, a3 #address m1 (nxk)
    mv s4, a4 #m1, n
    mv s5, a5 #m1, k
    mv s6, a6 #address prod d
    mv s11, s6 #copy of address d
    li s7, 0 #m0 incrementer
    li s8, 0 #m1 incrementer



li t4, 4
mul t2, t4, s5 #stride =#elements in col * bytes/element, stride m1
mv s9, t2 #stride m1
mv s10, s3 #copy of m1 address to increment
outer_loop_start:
    beq s7, s1, final
    mv a0, s0 #prep for dot call
    li a3, 1 #stride of row vector
    j inner_loop_start
    
inner_loop_start:
    beq s8, s5, inner_loop_end
    #prep for function call
    mv a4, s5 #stride of v2 = numcols
    mv a1, s10 #address of v2 to a1
    mv a2, s2 #put length of vectors (ncols of m1)
    jal dot  
    sw a0, 0(s6) #s6 address of d 
    mv a0, s0 #restore address of m0 to a0 for next call
    addi s6, s6, 4 #to ith element address of d
    addi s8, s8, 1
    addi s10, s10, 4 #increment start of vector
    j inner_loop_start


inner_loop_end:
    mv s10, s3 #restore base address of m1 
    mv s8, x0 #reset col counter
    li t4, 4
    mul t4, t4, s2 #offset to next row of m0 (4xncols)
    add s0, s0, t4 #update offset to ith address
    addi s7, s7, 1 #update row incrementer
    j outer_loop_start


outer_loop_end:
    mv a6, s11 #address to start of d
    lw ra, 0(sp) # Store the return address
    lw s0, 4(sp) # Store register s
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
    addi sp, sp, 52 #close stack
    jr t1
ex2:
	jal t1 outer_loop_end
    li a1, 2
    j exit2
exit3:
	jal t1 outer_loop_end
    li a1, 3
    j exit2
exit4:
	jal t1 outer_loop_end
    li a1, 4
    j exit2
final:
	jal t1 outer_loop_end
    ret