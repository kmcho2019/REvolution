module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals (shared for both greater and less)
    wire A_gt_B_bit2 = A[2] & ~B[2];
    wire B_gt_A_bit2 = ~A[2] & B[2];
    wire eq_bit2 = ~(A[2] ^ B[2]);
    
    wire A_gt_B_bit1 = A[1] & ~B[1];
    wire B_gt_A_bit1 = ~A[1] & B[1];
    wire eq_bit1 = ~(A[1] ^ B[1]);
    
    wire A_gt_B_bit0 = A[0] & ~B[0];
    wire B_gt_A_bit0 = ~A[0] & B[0];
    wire eq_bit0 = ~(A[0] ^ B[0]);

    // Shared intermediate terms
    wire gt_bit2 = A_gt_B_bit2;
    wire lt_bit2 = B_gt_A_bit2;
    wire eq_bits2_1 = eq_bit2 & eq_bit1;
    
    // Hierarchical comparison logic
    assign A_greater = gt_bit2 | 
                      (eq_bit2 & A_gt_B_bit1) | 
                      (eq_bits2_1 & A_gt_B_bit0);
    
    assign A_less = lt_bit2 | 
                   (eq_bit2 & B_gt_A_bit1) | 
                   (eq_bits2_1 & B_gt_A_bit0);
    
    assign A_equal = eq_bits2_1 & eq_bit0;

endmodule