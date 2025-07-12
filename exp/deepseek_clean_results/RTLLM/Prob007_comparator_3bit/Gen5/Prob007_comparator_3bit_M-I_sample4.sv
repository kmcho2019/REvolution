module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_eq = ~(A ^ B);  // Bit-wise equality
wire [2:0] bit_gt = A & ~B;    // Bit-wise greater than
wire [2:0] bit_lt = ~A & B;    // Bit-wise less than

// Hierarchical comparison (MSB first)
wire eq_2 = bit_eq[2];
wire gt_2 = bit_gt[2];
wire lt_2 = bit_lt[2];

wire eq_1 = eq_2 & bit_eq[1];
wire gt_1 = gt_2 | (eq_2 & bit_gt[1]);
wire lt_1 = lt_2 | (eq_2 & bit_lt[1]);

wire final_eq = eq_1 & bit_eq[0];
wire final_gt = gt_1 | (eq_1 & bit_gt[0]);
wire final_lt = lt_1 | (eq_1 & bit_lt[0]);

assign A_equal = final_eq;
assign A_greater = final_gt & ~final_eq;
assign A_less = final_lt & ~final_eq;

endmodule