module comparator_3bit(
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Generate local comparison signals for each bit
wire [2:0] bit_greater = A & ~B;
wire [2:0] bit_less = ~A & B;
wire [2:0] bit_equal = ~(A ^ B);

// Weighted combination of comparison results
wire greater_msb = bit_greater[2];
wire greater_mid = bit_equal[2] & bit_greater[1];
wire greater_lsb = bit_equal[2] & bit_equal[1] & bit_greater[0];

wire less_msb = bit_less[2];
wire less_mid = bit_equal[2] & bit_less[1];
wire less_lsb = bit_equal[2] & bit_equal[1] & bit_less[0];

// Final outputs
assign A_greater = greater_msb | greater_mid | greater_lsb;
assign A_less = less_msb | less_mid | less_lsb;
assign A_equal = &bit_equal;  // All bits equal

endmodule