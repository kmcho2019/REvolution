module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bitwise comparison signals
wire [2:0] bit_gt = A & ~B;
wire [2:0] bit_eq = ~(A ^ B);
wire [2:0] bit_lt = ~A & B;

// Hierarchical comparison (MSB has priority)
assign A_greater = bit_gt[2] | 
                  (bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[2] & bit_eq[1] & bit_gt[0]);

assign A_equal = &bit_eq;  // All bits equal

assign A_less = bit_lt[2] | 
               (bit_eq[2] & bit_lt[1]) | 
               (bit_eq[2] & bit_eq[1] & bit_lt[0]);

endmodule