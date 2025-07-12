module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_eq;  // Bit-wise equality
wire [2:0] bit_gt;  // Bit-wise greater than

// Generate bit-wise comparisons
assign bit_eq[2] = (A[2] ~^ B[2]);  // XNOR for equality
assign bit_gt[2] = (A[2] & ~B[2]);

assign bit_eq[1] = (A[1] ~^ B[1]);
assign bit_gt[1] = (A[1] & ~B[1]);

assign bit_eq[0] = (A[0] ~^ B[0]);
assign bit_gt[0] = (A[0] & ~B[0]);

// Hierarchical comparison (MSB first)
assign A_greater = bit_gt[2] | 
                  (bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[2] & bit_eq[1] & bit_gt[0]);

assign A_equal = &bit_eq;  // All bits equal

assign A_less = ~A_greater & ~A_equal;  // Mutually exclusive

endmodule