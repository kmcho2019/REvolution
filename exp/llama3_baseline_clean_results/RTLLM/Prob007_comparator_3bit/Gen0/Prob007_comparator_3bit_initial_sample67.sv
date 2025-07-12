module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less     // 1-bit output indicating if A is less than B
);

// Comparison logic using combinational logic
assign A_greater = (A > B) ? 1'b1 : 1'b0;
assign A_equal = (A == B) ? 1'b1 : 1'b0;
assign A_less = (A < B) ? 1'b1 : 1'b0;

endmodule