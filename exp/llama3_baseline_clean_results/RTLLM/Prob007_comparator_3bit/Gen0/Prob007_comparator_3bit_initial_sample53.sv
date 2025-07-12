module comparator_3bit(
    input [2:0] A,  // First 3-bit input operand
    input [2:0] B,  // Second 3-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less     // 1-bit output indicating if A is less than B
);

// Internal wires to compare A and B
wire A_greater_int;
wire A_equal_int;
wire A_less_int;

// Comparison logic
assign A_greater_int = (A > B) ? 1'b1 : 1'b0;
assign A_equal_int = (A == B) ? 1'b1 : 1'b0;
assign A_less_int = (A < B) ? 1'b1 : 1'b0;

// Ensure mutually exclusive outputs
assign A_greater = A_greater_int & ~A_equal_int & ~A_less_int;
assign A_equal = A_equal_int & ~A_greater_int & ~A_less_int;
assign A_less = A_less_int & ~A_greater_int & ~A_equal_int;

endmodule