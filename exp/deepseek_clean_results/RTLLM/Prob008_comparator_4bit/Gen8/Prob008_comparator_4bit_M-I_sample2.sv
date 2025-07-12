module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Parallel bit-wise comparison
wire [3:0] bit_gt = A & ~B;  // A > B at each bit
wire [3:0] bit_eq = ~(A ^ B); // A == B at each bit
wire [3:0] bit_lt = ~A & B;  // A < B at each bit

// First level prefix computation
wire gt_hi = bit_gt[3] | (bit_eq[3] & bit_gt[2]);
wire eq_hi = bit_eq[3] & bit_eq[2];
wire lt_hi = bit_lt[3] | (bit_eq[3] & bit_lt[2]);

wire gt_lo = bit_gt[1] | (bit_eq[1] & bit_gt[0]);
wire eq_lo = bit_eq[1] & bit_eq[0];
wire lt_lo = bit_lt[1] | (bit_eq[1] & bit_lt[0]);

// Final outputs
assign A_greater = gt_hi | (eq_hi & gt_lo);
assign A_equal = eq_hi & eq_lo;
assign A_less = lt_hi | (eq_hi & lt_lo);

endmodule