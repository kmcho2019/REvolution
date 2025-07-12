module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output A_greater,
    output A_equal,
    output A_less
);

// Perform subtraction A - B
wire [3:0] result;
wire borrow;

// Subtraction logic (4-bit subtractor)
assign result[0] = A[0] ^ B[0] ^ borrow;
assign borrow = (~A[0] & B[0]) | (~A[0] & borrow) | (B[0] & borrow);
assign result[1] = A[1] ^ B[1] ^ borrow;
assign borrow = (~A[1] & B[1]) | (~A[1] & borrow) | (B[1] & borrow);
assign result[2] = A[2] ^ B[2] ^ borrow;
assign borrow = (~A[2] & B[2]) | (~A[2] & borrow) | (B[2] & borrow);
assign result[3] = A[3] ^ B[3] ^ borrow;
assign borrow = (~A[3] & B[3]) | (~A[3] & borrow) | (B[3] & borrow);

// Determine comparison results
assign A_greater = (~borrow) & (|result); // A > B if no borrow and result is non-zero
assign A_equal = (~borrow) & (~|result); // A == B if no borrow and result is zero
assign A_less = borrow; // A < B if borrow

endmodule