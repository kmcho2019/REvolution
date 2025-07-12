module comparator_4bit(
    input [3:0] A,  // First 4-bit input operand
    input [3:0] B,  // Second 4-bit input operand
    output A_greater,  // 1-bit output indicating if A is greater than B
    output A_equal,    // 1-bit output indicating if A is equal to B
    output A_less      // 1-bit output indicating if A is less than B
);

// Perform subtraction operation (A - B) and analyze the result
wire [3:0] diff;
wire borrow;

assign diff = A - B;
assign borrow = (A < B)? 1 : 0;

// Generate A_greater signal
assign A_greater = (diff > 0 && borrow == 0)? 1 : 0;

// Generate A_equal signal
assign A_equal = (diff == 0 && borrow == 0)? 1 : 0;

// Generate A_less signal
assign A_less = borrow? 1 : 0;

endmodule