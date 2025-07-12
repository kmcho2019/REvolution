module comparator_4bit(
    input [3:0] A, // First 4-bit input operand
    input [3:0] B, // Second 4-bit input operand
    output A_greater, // 1-bit output indicating if A is greater than B
    output A_equal, // 1-bit output indicating if A is equal to B
    output A_less // 1-bit output indicating if A is less than B
);

// Perform subtraction A - B and generate borrow
wire [3:0] diff;
wire borrow;

// Assume a 4-bit subtractor (full subtractor for each bit)
assign {borrow, diff[3:0]} = A - {1'b0, B};

// Determine if A is less than B based on borrow
assign A_less = borrow;

// Determine if A is equal to B based on subtraction result
assign A_equal = ~(diff[3:0] | borrow);

// Determine if A is greater than B based on no borrow and non-zero result
assign A_greater = ~A_less & ~A_equal;

endmodule