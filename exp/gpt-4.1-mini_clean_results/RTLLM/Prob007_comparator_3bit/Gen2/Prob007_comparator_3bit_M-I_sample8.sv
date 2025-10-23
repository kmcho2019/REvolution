module comparator_3bit (
    input  [2:0] A,
    input  [2:0] B,
    output       A_greater,
    output       A_equal,
    output       A_less
);

wire bit2_gt, bit2_eq, bit2_lt;
wire bit1_gt, bit1_eq, bit1_lt;
wire bit0_gt, bit0_eq, bit0_lt;

// Compare bit 2 (MSB)
assign bit2_gt = A[2] & ~B[2];
assign bit2_lt = ~A[2] & B[2];
assign bit2_eq = ~(bit2_gt | bit2_lt);

// Compare bit 1
assign bit1_gt = A[1] & ~B[1];
assign bit1_lt = ~A[1] & B[1];
assign bit1_eq = ~(bit1_gt | bit1_lt);

// Compare bit 0 (LSB)
assign bit0_gt = A[0] & ~B[0];
assign bit0_lt = ~A[0] & B[0];
assign bit0_eq = ~(bit0_gt | bit0_lt);

// Determine A_greater
assign A_greater = bit2_gt |
                   (bit2_eq & bit1_gt) |
                   (bit2_eq & bit1_eq & bit0_gt);

// Determine A_less
assign A_less = bit2_lt |
                (bit2_eq & bit1_lt) |
                (bit2_eq & bit1_eq & bit0_lt);

// Determine A_equal
assign A_equal = bit2_eq & bit1_eq & bit0_eq;

endmodule