module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

// Perform 64-bit binary subtraction
assign result = A - B;

// Detect overflow conditions based on the sign bits of A, B, and the result
assign overflow = (
    // Positive overflow: A is positive, B is negative, and the result is negative
    (~A[63] & B[63] & result[63]) |
    // Negative overflow: A is negative, B is positive, and the result is positive
    (A[63] & ~B[63] & ~result[63])
);

endmodule