module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output A_greater,  // 1 if A is greater than B
    output A_equal,   // 1 if A is equal to B
    output A_less    // 1 if A is less than B
);

// Directly assign comparison results to outputs
assign A_greater = (A > B);
assign A_equal = (A == B);
assign A_less = (A < B);

endmodule