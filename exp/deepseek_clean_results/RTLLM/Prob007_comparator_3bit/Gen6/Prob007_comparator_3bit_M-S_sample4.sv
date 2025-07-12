module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_equal;
wire [2:0] bit_A_greater;
wire [2:0] bit_A_less;

// Bitwise comparison
assign bit_equal = ~(A ^ B);
assign bit_A_greater = A & ~B;
assign bit_A_less = ~A & B;

// Final outputs with priority encoding (MSB first)
assign A_greater = bit_A_greater[2] | 
                  (bit_equal[2] & bit_A_greater[1]) | 
                  (bit_equal[2] & bit_equal[1] & bit_A_greater[0]);

assign A_less = bit_A_less[2] | 
               (bit_equal[2] & bit_A_less[1]) | 
               (bit_equal[2] & bit_equal[1] & bit_A_less[0]);

assign A_equal = &bit_equal;  // All bits equal

endmodule