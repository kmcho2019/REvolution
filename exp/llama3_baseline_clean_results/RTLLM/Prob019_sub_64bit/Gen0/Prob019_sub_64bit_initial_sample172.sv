module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform binary subtraction of A and B
assign result = A - B;

// Determine the sign of A, B, and the result
wire sign_A = A[63];  // MSB of A (1 for negative, 0 for positive)
wire sign_B = B[63];  // MSB of B (1 for negative, 0 for positive)
wire sign_result = result[63];  // MSB of result (1 for negative, 0 for positive)

// Check for overflow conditions
// Positive overflow: A is positive, B is negative, and the result is negative
// Negative overflow: A is negative, B is positive, and the result is positive
assign overflow = (~sign_A & sign_B & sign_result) | (sign_A & ~sign_B & ~sign_result);

endmodule