.import ../../src/dot.s
.import ../../src/utils.s

# Set vector values for testing
.data
vector0: .word 1 2 3 4 5 6 7 8 9
vector1: .word 1 2 3 4 5 6 7 8 9


.text
# main function for testing
main:
    # Load vector addresses into registers
    la s0 vector0
    la s1 vector1
    mv a0, s0
    mv a1, s1
    # Set vector attributes
    li a2, 9 #length
    li a3, 1 #stride v1
    li a4, 1 #stride v2

    # Call dot function
    jal ra dot


    # Print integer result
    mv a1 a0
    jal ra print_int

    # Print newline
    li a1 '\n'
    jal ra print_char
    
    # Print newline
    # Exit
    jal exit


 



  
