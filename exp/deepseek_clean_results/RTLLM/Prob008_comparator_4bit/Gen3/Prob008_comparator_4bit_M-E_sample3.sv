module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Intermediate signals for each bit position
    wire [3:0] bit_equal;
    wire [3:0] bit_greater;
    
    // Generate comparison signals for each bit
    assign bit_equal = ~(A ^ B);  // 1 when bits are equal
    
    assign bit_greater[3] = A[3] & ~B[3];
    assign bit_greater[2] = bit_equal[3] & A[2] & ~B[2];
    assign bit_greater[1] = bit_equal[3] & bit_equal[2] & A[1] & ~B[1];
    assign bit_greater[0] = bit_equal[3] & bit_equal[2] & bit_equal[1] & A[0] & ~B[0];
    
    // Generate less signals similarly
    wire [3:0] bit_less;
    assign bit_less[3] = ~A[3] & B[3];
    assign bit_less[2] = bit_equal[3] & ~A[2] & B[2];
    assign bit_less[1] = bit_equal[3] & bit_equal[2] & ~A[1] & B[1];
    assign bit_less[0] = bit_equal[3] & bit_equal[2] & bit_equal[1] & ~A[0] & B[0];
    
    // Final outputs
    assign A_equal = &bit_equal;  // All bits equal
    assign A_greater = |bit_greater;
    assign A_less = |bit_less;

endmodule