module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction
    assign result = A - B;

    // Overflow detection
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];

    assign overflow = (~A_sign & B_sign & result_sign) |  // Positive overflow
                     (A_sign & ~B_sign & ~result_sign);  // Negative overflow

endmodule