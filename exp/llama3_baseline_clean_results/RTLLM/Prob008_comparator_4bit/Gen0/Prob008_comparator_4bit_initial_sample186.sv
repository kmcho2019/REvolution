module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

wire [3:0] result;  // Result of subtraction A - B
wire borrow;        // Borrow bit generated during subtraction

// Perform subtraction A - B using a 4-bit subtractor
assign {borrow, result} = A - B;

// Determine the output based on the result and borrow
assign A_greater = (~borrow) & (|result);  // A > B if no borrow and result is non-zero
assign A_equal = ~(borrow | (|result));    // A == B if no borrow and result is zero
assign A_less = borrow;                     // A < B if borrow occurs

endmodule