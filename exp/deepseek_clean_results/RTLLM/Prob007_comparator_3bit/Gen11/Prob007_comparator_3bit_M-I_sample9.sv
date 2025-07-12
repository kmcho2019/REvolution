module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_eq;  // Bit-wise equality
wire [2:0] bit_gt;   // Bit-wise greater than

// Bit-wise comparison
assign bit_eq = ~(A ^ B);
assign bit_gt[2] = A[2] & ~B[2];
assign bit_gt[1] = A[1] & ~B[1] & bit_eq[2];
assign bit_gt[0] = A[0] & ~B[0] & bit_eq[2] & bit_eq[1];

// Output generation
assign A_equal = &bit_eq;
assign A_greater = |bit_gt;
assign A_less = ~A_equal & ~A_greater;  // Mutually exclusive by construction

endmodule