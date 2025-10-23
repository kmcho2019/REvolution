module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Individual bit comparisons
    wire bit3_gt = A[3] & ~B[3];
    wire bit3_eq = A[3] ~^ B[3];
    
    wire bit2_gt = A[2] & ~B[2];
    wire bit2_eq = A[2] ~^ B[2];
    
    wire bit1_gt = A[1] & ~B[1];
    wire bit1_eq = A[1] ~^ B[1];
    
    wire bit0_gt = A[0] & ~B[0];
    wire bit0_eq = A[0] ~^ B[0];

    // Hierarchical combination
    wire gt_hi = bit3_gt | (bit3_eq & bit2_gt) | 
                (bit3_eq & bit2_eq & bit1_gt) |
                (bit3_eq & bit2_eq & bit1_eq & bit0_gt);
                
    wire eq_all = bit3_eq & bit2_eq & bit1_eq & bit0_eq;

    // Output assignments
    assign A_greater = gt_hi;
    assign A_equal = eq_all;
    assign A_less = ~eq_all & ~gt_hi;

endmodule