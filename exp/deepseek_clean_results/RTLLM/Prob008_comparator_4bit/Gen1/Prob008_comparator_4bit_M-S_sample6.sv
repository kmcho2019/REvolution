module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bitwise equality
    wire [3:0] bit_eq = ~(A ^ B);
    
    // Comparison from MSB to LSB
    wire A_gt_B = (A[3] & ~B[3]) |
                 (bit_eq[3] & A[2] & ~B[2]) |
                 (bit_eq[3] & bit_eq[2] & A[1] & ~B[1]) |
                 (bit_eq[3] & bit_eq[2] & bit_eq[1] & A[0] & ~B[0]);
    
    wire A_lt_B = (~A[3] & B[3]) |
                 (bit_eq[3] & ~A[2] & B[2]) |
                 (bit_eq[3] & bit_eq[2] & ~A[1] & B[1]) |
                 (bit_eq[3] & bit_eq[2] & bit_eq[1] & ~A[0] & B[0]);
    
    // Output assignments
    assign A_equal = &bit_eq;
    assign A_greater = A_gt_B;
    assign A_less = A_lt_B;

endmodule