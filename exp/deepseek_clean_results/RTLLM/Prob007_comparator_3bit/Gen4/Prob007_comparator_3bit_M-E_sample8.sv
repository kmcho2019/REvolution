module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-slice comparison signals
wire [2:0] bit_greater;
wire [2:0] bit_equal;
wire [2:0] bit_less;

// Generate comparison for each bit
assign bit_greater[2] = A[2] & ~B[2];
assign bit_equal[2]   = ~(A[2] ^ B[2]);
assign bit_less[2]    = ~A[2] & B[2];

assign bit_greater[1] = A[1] & ~B[1];
assign bit_equal[1]   = ~(A[1] ^ B[1]);
assign bit_less[1]    = ~A[1] & B[1];

assign bit_greater[0] = A[0] & ~B[0];
assign bit_equal[0]   = ~(A[0] ^ B[0]);
assign bit_less[0]    = ~A[0] & B[0];

// Hierarchical comparison logic
wire msb_diff = ~bit_equal[2];
wire mid_diff = ~bit_equal[1];
wire lsb_diff = ~bit_equal[0];

// Final output determination with priority encoding
assign A_greater = bit_greater[2] | 
                  (bit_equal[2] & bit_greater[1]) | 
                  (bit_equal[2] & bit_equal[1] & bit_greater[0]);

assign A_equal = bit_equal[2] & bit_equal[1] & bit_equal[0];

assign A_less = bit_less[2] | 
               (bit_equal[2] & bit_less[1]) | 
               (bit_equal[2] & bit_equal[1] & bit_less[0]);

// Assertion for mutual exclusivity (commented out for synthesis)
// assert property (@(posedge clk) $onehot0({A_greater, A_equal, A_less}));

endmodule