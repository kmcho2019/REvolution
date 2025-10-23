module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise equality (more compact implementation)
wire [2:0] bit_eq = ~(A ^ B);

// Hierarchical comparison with balanced structure
wire gt_msb = A[2] & ~B[2];
wire eq_msb = bit_eq[2];

wire gt_mid = eq_msb & (A[1] & ~B[1]);
wire eq_mid = eq_msb & bit_eq[1];

wire gt_lsb = eq_mid & (A[0] & ~B[0]);
wire lt_lsb = eq_mid & (~A[0] & B[0]);

// Full equality (AND reduction)
assign A_equal = &bit_eq;

// Balanced OR tree for greater comparison
wire gt_or1 = gt_msb | gt_mid;
assign A_greater = gt_or1 | gt_lsb;

// Direct less comparison (parallel to greater)
wire lt_or1 = (~A[2] & B[2]) | (eq_msb & ~A[1] & B[1]);
assign A_less = lt_or1 | lt_lsb;

endmodule