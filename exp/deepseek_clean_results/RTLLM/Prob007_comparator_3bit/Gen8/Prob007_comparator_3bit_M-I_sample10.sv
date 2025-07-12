module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_equal;
wire [2:0] bit_greater;

// Bitwise comparison
assign bit_equal = ~(A ^ B);       // 1 when bits are equal
assign bit_greater = A & ~B;       // 1 when A's bit is greater

// Hierarchical comparison (MSB first)
assign A_greater = bit_greater[2] | 
                  (bit_equal[2] & bit_greater[1]) | 
                  (bit_equal[2] & bit_equal[1] & bit_greater[0]);

assign A_equal = &bit_equal;       // All bits equal

assign A_less = ~A_greater & ~A_equal;  // Mutually exclusive

endmodule