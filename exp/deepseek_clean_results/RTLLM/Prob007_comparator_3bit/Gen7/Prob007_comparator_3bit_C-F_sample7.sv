module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals (optimized for synthesis)
    wire A_gt_B_bit2 = A[2] & ~B[2];
    wire A_eq_B_bit2 = A[2] ~^ B[2];
    wire A_lt_B_bit2 = ~A[2] & B[2];
    
    wire A_gt_B_bit1 = A[1] & ~B[1];
    wire A_eq_B_bit1 = A[1] ~^ B[1];
    wire A_lt_B_bit1 = ~A[1] & B[1];
    
    wire A_gt_B_bit0 = A[0] & ~B[0];
    wire A_eq_B_bit0 = A[0] ~^ B[0];
    wire A_lt_B_bit0 = ~A[0] & B[0];

    // Hierarchical comparison with clear priority
    assign A_greater = A_gt_B_bit2 |
                      (A_eq_B_bit2 & A_gt_B_bit1) |
                      (A_eq_B_bit2 & A_eq_B_bit1 & A_gt_B_bit0);

    // Direct arithmetic equality check
    assign A_equal = (A == B);

    // Direct less-than implementation for better timing
    assign A_less = A_lt_B_bit2 |
                   (A_eq_B_bit2 & A_lt_B_bit1) |
                   (A_eq_B_bit2 & A_eq_B_bit1 & A_lt_B_bit0);

endmodule