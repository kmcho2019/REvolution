// Define the module comparator_4bit
module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // Output indicating if A is greater than B
    output A_equal,    // Output indicating if A is equal to B
    output A_less      // Output indicating if A is less than B
);

// Perform the subtraction operation: A - B
wire [3:0] diff;
wire borrow;

// We will use a full subtractor for each bit
// However, for simplicity and considering we're comparing, we can directly use arithmetic operations
assign diff = A - B;
assign borrow = (B > A) ? 1'b1 : 1'b0;

// Determine the outputs based on the result of subtraction and borrow
assign A_greater = (~borrow) & (diff != 4'b0000);
assign A_equal = (~borrow) & (diff == 4'b0000);
assign A_less = borrow;

endmodule