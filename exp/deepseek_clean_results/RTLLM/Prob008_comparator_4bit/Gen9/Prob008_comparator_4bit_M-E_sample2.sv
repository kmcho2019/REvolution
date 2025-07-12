module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] bit_eq;    // Bit-wise equality
wire [3:0] bit_gt;    // Bit-wise greater than
wire [3:0] bit_lt;    // Bit-wise less than

// Generate bit-wise comparison signals
assign bit_eq = ~(A ^ B);
assign bit_gt = A & ~B;
assign bit_lt = ~A & B;

// Carry-chain style comparison propagation
wire gt_chain, lt_chain;
assign gt_chain = bit_gt[0] | (bit_eq[0] & (bit_gt[1] | (bit_eq[1] & (bit_gt[2] | (bit_eq[2] & bit_gt[3]))));
assign lt_chain = bit_lt[0] | (bit_eq[0] & (bit_lt[1] | (bit_eq[1] & (bit_lt[2] | (bit_eq[2] & bit_lt[3])))));

// Final outputs
assign A_equal = &bit_eq;
assign A_greater = gt_chain & ~A_equal;
assign A_less = lt_chain & ~A_equal;

endmodule