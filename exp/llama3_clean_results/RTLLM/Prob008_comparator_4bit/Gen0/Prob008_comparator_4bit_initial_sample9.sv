module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B
wire [3:0] diff;
wire borrow;

// Subtract B from A
assign {borrow, diff} = A - B;

// Check conditions for A_greater, A_equal, and A_less
assign A_greater = (borrow == 0) && (diff != 0);
assign A_equal = (borrow == 0) && (diff == 0);
assign A_less = borrow;

endmodule