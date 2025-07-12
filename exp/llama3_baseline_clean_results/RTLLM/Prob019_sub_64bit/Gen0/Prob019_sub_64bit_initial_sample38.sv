module sub_64bit(
    input [63:0] A,
    input [63:0] B,
    output [63:0] result,
    output overflow
);

    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];

    // Positive overflow: A is positive, B is negative, result is negative
    // Negative overflow: A is negative, B is positive, result is positive
    assign overflow = (~A_sign & B_sign & result_sign) | (A_sign & ~B_sign & ~result_sign);

endmodule