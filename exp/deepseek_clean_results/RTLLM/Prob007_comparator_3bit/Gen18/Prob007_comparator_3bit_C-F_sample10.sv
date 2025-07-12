module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // MSB comparison (highest priority)
    wire A_gt_MSB = A[2] & ~B[2];
    wire A_eq_MSB = ~(A[2] ^ B[2]);
    
    // Middle bit comparison (if MSB equal)
    wire A_gt_mid = A_eq_MSB & (A[1] & ~B[1]);
    wire A_eq_mid = A_eq_MSB & ~(A[1] ^ B[1]);
    
    // LSB comparison (if both higher bits equal)
    wire A_gt_lsb = A_eq_mid & (A[0] & ~B[0]);
    wire A_eq_all = A_eq_mid & ~(A[0] ^ B[0]);

    // Final outputs - computed directly from comparison results
    assign A_greater = A_gt_MSB | A_gt_mid | A_gt_lsb;
    assign A_equal = A_eq_all;
    assign A_less = ~(A_greater | A_equal);  // More efficient than separate comparison

endmodule