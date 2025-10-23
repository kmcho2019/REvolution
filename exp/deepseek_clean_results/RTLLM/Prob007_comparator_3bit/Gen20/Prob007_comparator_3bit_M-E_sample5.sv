module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Convert inputs to thermometer code (unary representation)
wire [7:0] therm_A = (1 << A) - 1;
wire [7:0] therm_B = (1 << B) - 1;

// Parallel comparison of thermometer codes
wire [7:0] diff = therm_A ^ therm_B;
wire [7:0] gt_bits = therm_A & ~therm_B;
wire [7:0] lt_bits = ~therm_A & therm_B;

// Priority encoding of comparison results
assign A_greater = |gt_bits;
assign A_less = |lt_bits;
assign A_equal = ~(A_greater | A_less);  // Mutually exclusive

endmodule