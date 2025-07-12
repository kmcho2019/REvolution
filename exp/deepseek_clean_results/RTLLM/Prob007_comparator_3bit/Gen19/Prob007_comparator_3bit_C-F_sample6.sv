module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

    // Shared equality detection (power efficient)
    wire [2:0] bit_eq = ~(A ^ B);
    wire all_equal = &bit_eq;

    // Magnitude comparison (optimized hierarchical approach)
    wire A_gt_MSB = A[2] & ~B[2];
    wire A_lt_MSB = ~A[2] & B[2];
    wire eq_MSB = bit_eq[2];

    wire A_gt_mid = eq_MSB & (A[1] & ~B[1]);
    wire A_lt_mid = eq_MSB & (~A[1] & B[1]);
    wire eq_mid = eq_MSB & bit_eq[1];

    wire A_gt_lsb = eq_mid & (A[0] & ~B[0]);
    wire A_lt_lsb = eq_mid & (~A[0] & B[0]);

    // Final outputs (mutually exclusive)
    assign A_greater = A_gt_MSB | A_gt_mid | A_gt_lsb;
    assign A_equal = all_equal;
    assign A_less = A_lt_MSB | A_lt_mid | A_lt_lsb;

endmodule