module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

    // Perform subtraction using the - operator
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire A_sign = A[63];
    wire B_sign = B[63];
    wire result_sign = result[63];

    // Overflow conditions
    // Positive overflow: A is positive, B is negative, and the result is negative
    // Negative overflow: A is negative, B is positive, and the result is positive
    assign overflow = (A_sign == 0 && B_sign == 1 && result_sign == 1) ||
                     (A_sign == 1 && B_sign == 0 && result_sign == 0);

endmodule