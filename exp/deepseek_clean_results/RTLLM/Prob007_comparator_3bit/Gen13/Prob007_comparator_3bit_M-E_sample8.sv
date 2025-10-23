module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Generate bitwise comparison signals
wire [2:0] bit_eq = ~(A ^ B);  // Bit equality
wire [2:0] bit_gt = A & ~B;    // Bit greater-than

// Parallel prefix computation
wire eq_2_1 = bit_eq[2] & bit_eq[1];
wire gt_2_1 = bit_gt[2] | (bit_eq[2] & bit_gt[1]);

wire eq_all = eq_2_1 & bit_eq[0];
wire gt_any = gt_2_1 | (eq_2_1 & bit_gt[0]);

// Final outputs with one-hot encoding
assign A_greater = gt_any;
assign A_equal = eq_all;
assign A_less = ~(gt_any | eq_all);  // Mutually exclusive

endmodule