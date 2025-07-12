module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B and generate borrow signal
wire [3:0] diff;
wire borrow;

// Assume a full subtractor is available for each bit position
assign {borrow, diff[3:0]} = A - B;

// Determine if A is greater than B
assign A_greater = ~borrow & ~(|diff);  // Not accurate since we need to check for non-zero result

// Correct implementation for A_greater, A_equal, and A_less
assign A_greater = ~borrow & (|diff);  // If no borrow and non-zero result, A is greater
assign A_equal = ~borrow & ~(|diff);   // If no borrow and zero result, A is equal
assign A_less = borrow;                // If borrow, A is less

endmodule