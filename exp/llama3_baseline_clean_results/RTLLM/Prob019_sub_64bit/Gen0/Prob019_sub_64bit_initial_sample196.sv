module sub_64bit (
    input   [63:0] A,      // First 64-bit input operand
    input   [63:0] B,      // Second 64-bit input operand
    output  [63:0] result, // 64-bit output representing the difference of A and B
    output         overflow // 1-bit output indicating whether an overflow occurred
);

// Perform subtraction
assign result = A - B;

// Check for overflow conditions
// Positive overflow: A is positive, B is negative, and result is negative
// Negative overflow: A is negative, B is positive, and result is positive
assign overflow = ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63]));

endmodule