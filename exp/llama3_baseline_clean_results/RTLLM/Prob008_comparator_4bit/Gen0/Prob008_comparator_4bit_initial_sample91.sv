module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Internal wire to hold the result of subtraction
wire [3:0] result;

// Perform subtraction A - B
assign result = A - B;

// Determine if A is greater than B
assign A_greater = (result > 0) ? 1'b1 : 1'b0;

// Determine if A is equal to B
assign A_equal = (A == B) ? 1'b1 : 1'b0;

// Determine if A is less than B
assign A_less = (result < 0) ? 1'b1 : 1'b0;

endmodule