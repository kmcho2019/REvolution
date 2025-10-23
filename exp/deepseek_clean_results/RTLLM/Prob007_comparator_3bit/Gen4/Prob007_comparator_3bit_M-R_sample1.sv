module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Bit-wise comparison signals
    wire A_gt_B_bit2 = A[2] & ~B[2];
    wire A_eq_B_bit2 = A[2] ~^ B[2];
    
    wire A_gt_B_bit1 = A[1] & ~B[1];
    wire A_eq_B_bit1 = A[1] ~^ B[1];
    
    wire A_gt_B_bit0 = A[0] & ~B[0];
    wire A_eq_B_bit0 = A[0] ~^ B[0];

    // Hierarchical comparison logic
    assign A_greater = A_gt_B_bit2 | 
                      (A_eq_B_bit2 & A_gt_B_bit1) | 
                      (A_eq_B_bit2 & A_eq_B_bit1 & A_gt_B_bit0);
    
    assign A_equal = A_eq_B_bit2 & A_eq_B_bit1 & A_eq_B_bit0;
    
    assign A_less = ~A_greater & ~A_equal;

endmodule