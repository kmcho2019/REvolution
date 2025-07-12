module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise comparison signals
wire [2:0] bit_eq = ~(A ^ B);  // 1 when bits are equal
wire [2:0] bit_gt = A & ~B;    // 1 when A's bit is greater

// Hierarchical comparison logic
wire gt_msb = bit_gt[2];
wire eq_msb = bit_eq[2];

wire gt_mid = eq_msb & bit_gt[1];
wire eq_mid = eq_msb & bit_eq[1];

wire gt_lsb = eq_mid & bit_gt[0];
wire eq_lsb = eq_mid & bit_eq[0];

// Final outputs
assign A_greater = gt_msb | gt_mid | gt_lsb;
assign A_equal = eq_lsb;
assign A_less = ~(A_greater | A_equal);  // Mutually exclusive by design

endmodule