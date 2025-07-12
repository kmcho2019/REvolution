module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bitwise equality
wire [2:0] bit_eq;
assign bit_eq[2] = ~(A[2] ^ B[2]);
assign bit_eq[1] = ~(A[1] ^ B[1]);
assign bit_eq[0] = ~(A[0] ^ B[0]);

// Hierarchical comparison
wire A_gt_MSB = A[2] & ~B[2];
wire A_lt_MSB = ~A[2] & B[2];
wire eq_MSB = bit_eq[2];

wire A_gt_MID = eq_MSB & A[1] & ~B[1];
wire A_lt_MID = eq_MSB & ~A[1] & B[1];
wire eq_MID = eq_MSB & bit_eq[1];

wire A_gt_LSB = eq_MID & A[0] & ~B[0];
wire A_lt_LSB = eq_MID & ~A[0] & B[0];

// Output assignment
assign A_greater = A_gt_MSB | A_gt_MID | A_gt_LSB;
assign A_equal = eq_MID & bit_eq[0];
assign A_less = A_lt_MSB | A_lt_MID | A_lt_LSB;

endmodule