module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Internal wires for comparison
wire A_gt_B;
wire A_eq_B;
wire A_lt_B;

// Compare A and B
assign A_gt_B = (A > B) ? 1'b1 : 1'b0;
assign A_eq_B = (A == B) ? 1'b1 : 1'b0;
assign A_lt_B = (A < B) ? 1'b1 : 1'b0;

// Assign outputs based on comparison results
assign A_greater = A_gt_B & ~A_eq_B & ~A_lt_B;
assign A_equal = A_eq_B & ~A_gt_B & ~A_lt_B;
assign A_less = A_lt_B & ~A_gt_B & ~A_eq_B;

endmodule