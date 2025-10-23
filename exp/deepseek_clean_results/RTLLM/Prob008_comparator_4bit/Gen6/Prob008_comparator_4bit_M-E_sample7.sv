module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise comparison results
wire [3:0] bit_gt;  // A's bit > B's bit at each position
wire [3:0] bit_eq;  // A's bit == B's bit at each position

// Generate comparison for each bit
assign bit_gt = A & ~B;
assign bit_eq = ~(A ^ B);

// Hierarchical comparison with priority to higher bits
wire gt3 = bit_gt[3];
wire eq3 = bit_eq[3];
wire gt2 = eq3 & bit_gt[2];
wire eq2 = eq3 & bit_eq[2];
wire gt1 = eq2 & bit_gt[1];
wire eq1 = eq2 & bit_eq[1];
wire gt0 = eq1 & bit_gt[0];
wire eq0 = eq1 & bit_eq[0];

// Final outputs
assign A_greater = gt3 | gt2 | gt1 | gt0;
assign A_equal = eq0;
assign A_less = ~A_greater & ~A_equal;

endmodule