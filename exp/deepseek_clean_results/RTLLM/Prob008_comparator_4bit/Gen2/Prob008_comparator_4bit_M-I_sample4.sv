module comparator_4bit (
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [3:0] bit_eq;   // Bit-wise equality
wire [3:0] bit_gt;    // Bit-wise greater than
wire [3:0] bit_lt;    // Bit-wise less than

// Bit-wise comparison
assign bit_eq = ~(A ^ B);
assign bit_gt = A & ~B;
assign bit_lt = ~A & B;

// Hierarchical comparison logic
wire gt3 = bit_gt[3];
wire lt3 = bit_lt[3];
wire eq3 = bit_eq[3];

wire gt2 = eq3 & bit_gt[2];
wire lt2 = eq3 & bit_lt[2];
wire eq2 = eq3 & bit_eq[2];

wire gt1 = eq2 & bit_gt[1];
wire lt1 = eq2 & bit_lt[1];
wire eq1 = eq2 & bit_eq[1];

wire gt0 = eq1 & bit_gt[0];
wire lt0 = eq1 & bit_lt[0];
wire eq0 = eq1 & bit_eq[0];

// Final outputs
assign A_greater = gt3 | gt2 | gt1 | gt0;
assign A_equal = eq0;
assign A_less = lt3 | lt2 | lt1 | lt0;

endmodule