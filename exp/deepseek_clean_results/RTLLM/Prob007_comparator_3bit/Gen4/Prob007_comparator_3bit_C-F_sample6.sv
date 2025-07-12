module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Hierarchical comparison with direct operators
    wire gt_msb = A[2] > B[2];
    wire eq_msb = A[2] == B[2];
    
    wire gt_mid = A[1] > B[1];
    wire eq_mid = A[1] == B[1];
    
    wire gt_lsb = A[0] > B[0];
    
    // Priority-encoded outputs (mutually exclusive by construction)
    assign A_greater = gt_msb | (eq_msb & gt_mid) | (eq_msb & eq_mid & gt_lsb);
    assign A_equal = eq_msb & eq_mid & (A[0] == B[0]);
    assign A_less = ~A_greater & ~A_equal;

endmodule