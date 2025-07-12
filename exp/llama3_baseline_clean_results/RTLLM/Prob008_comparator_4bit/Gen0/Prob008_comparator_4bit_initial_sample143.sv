module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B
wire [3:0] diff;
wire borrow;

// Use a 4-bit subtractor to compute A - B and the borrow
assign {borrow, diff} = A - {1'b0, B};

// Determine if A is greater than B (no borrow and result is non-zero)
assign A_greater = (~borrow) & (|diff);

// Determine if A is equal to B (result of subtraction is zero and no borrow)
assign A_equal = (~borrow) & (~|diff);

// Determine if A is less than B (borrow occurred)
assign A_less = borrow;

endmodule