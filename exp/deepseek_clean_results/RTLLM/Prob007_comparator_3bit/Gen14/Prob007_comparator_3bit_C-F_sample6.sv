module comparator_3bit (
    input [2:0] A,
    input [2:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Bit-wise comparison signals (shared by both approaches)
wire [2:0] bit_eq = ~(A ^ B);  // Bit equality
wire [2:0] bit_gt = A & ~B;    // Bit greater-than

// Fused comparison logic
wire eq_high = bit_eq[2] & bit_eq[1];  // MSB and middle bit equal
wire gt_high = bit_gt[2] | (bit_eq[2] & bit_gt[1]);  // MSB or middle bit greater

// Final comparison with LSB
assign A_greater = gt_high | (eq_high & bit_gt[0]);
assign A_equal = eq_high & bit_eq[0];
assign A_less = ~(A_greater | A_equal);  // Structural mutual exclusivity

endmodule