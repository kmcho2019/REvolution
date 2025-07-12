module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Shared equality terms (optimized for power and area)
wire [2:0] bit_eq = ~(A ^ B);  // 1 when bits are equal

// Hierarchical comparison with early termination
wire gt_msb = (A[2] & ~B[2]);
wire eq_msb = bit_eq[2];

wire gt_mid = eq_msb & (A[1] & ~B[1]);
wire eq_mid = eq_msb & bit_eq[1];

wire gt_lsb = eq_mid & (A[0] & ~B[0]);
wire lt_lsb = eq_mid & (~A[0] & B[0]);
wire eq_all = eq_mid & bit_eq[0];  // Full equality

// Final outputs (mutually exclusive by construction)
assign A_greater = gt_msb | gt_mid | gt_lsb;
assign A_equal = eq_all;
assign A_less = (~eq_msb & ~A[2] & B[2]) | 
                (eq_msb & ~A[1] & B[1]) | 
                (eq_mid & ~A[0] & B[0]);

endmodule