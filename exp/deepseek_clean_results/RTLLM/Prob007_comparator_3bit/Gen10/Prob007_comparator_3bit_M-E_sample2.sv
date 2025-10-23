module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bitwise comparison results
wire [2:0] bit_gt = A & ~B;
wire [2:0] bit_eq = ~(A ^ B);
wire [2:0] bit_lt = ~A & B;

// Hierarchical comparison logic
wire gt_msb = bit_gt[2];
wire eq_msb = bit_eq[2];
wire lt_msb = bit_lt[2];

wire gt_mid = eq_msb & bit_gt[1];
wire eq_mid = eq_msb & bit_eq[1];
wire lt_mid = eq_msb & bit_lt[1];

wire gt_lsb = eq_mid & bit_gt[0];
wire eq_lsb = eq_mid & bit_eq[0];
wire lt_lsb = eq_mid & bit_lt[0];

// Final outputs with priority encoding
assign A_greater = gt_msb | gt_mid | gt_lsb;
assign A_equal = eq_msb & eq_mid & eq_lsb;
assign A_less = lt_msb | lt_mid | lt_lsb;

endmodule