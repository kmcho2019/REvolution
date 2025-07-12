module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,   // 1-bit output indicating if A is equal to B
    output A_less    // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B
wire [3:0] diff;
assign diff = A - B;

// Determine if A is greater than, equal to, or less than B
assign A_greater = (diff[3] == 0) && (diff != 4'b0000);  // No borrow and result is non-zero
assign A_equal = (diff == 4'b0000);  // Result of subtraction is zero
assign A_less = (diff[3] == 1);  // Borrow occurred during subtraction

endmodule