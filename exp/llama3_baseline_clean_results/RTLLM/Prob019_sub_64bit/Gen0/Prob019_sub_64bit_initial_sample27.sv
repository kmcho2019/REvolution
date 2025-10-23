module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Check for overflow conditions
    // Positive overflow occurs when A is positive, B is negative, and result is negative
    // Negative overflow occurs when A is negative, B is positive, and result is positive
    assign overflow = ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63]));

endmodule