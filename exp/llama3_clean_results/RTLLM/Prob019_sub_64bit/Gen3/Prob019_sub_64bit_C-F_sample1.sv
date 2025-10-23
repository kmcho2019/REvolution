module sub_64bit (
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output         overflow
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Check for overflow conditions by examining the sign bits of A, B, and the result
    assign overflow = (
        // Positive overflow: A is positive, B is negative, and result is negative
        (A[63] == 'b0 && B == 1'b1 && result[63] == 1'b1) ||
        // Negative overflow: A is negative, B is positive, and result is positive
        (A[63] == 1'b1 && B == 1'b0 && result[63] == 1'b0)
    );

endmodule