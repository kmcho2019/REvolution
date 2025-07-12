module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

wire [2:0] bit_eq = ~(A ^ B);  // 1 where bits are equal
wire [2:0] bit_gt = A & ~B;    // 1 where A's bit is 1 and B's is 0

// Hierarchical comparison (MSB first)
assign A_greater = bit_gt[2] | 
                  (bit_eq[2] & bit_gt[1]) | 
                  (bit_eq[2] & bit_eq[1] & bit_gt[0]);

assign A_equal = &bit_eq;  // All bits equal

assign A_less = ~A_greater & ~A_equal;  // By mutual exclusion

endmodule