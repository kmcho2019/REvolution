module sub_64bit(
    input   [63:0] A,
    input   [63:0] B,
    output  [63:0] result,
    output          overflow
);

    // Perform subtraction
    assign result = A - B;

    // Extract sign bits of A, B, and result for overflow detection
    assign sign_A = A[63];
    assign sign_B = B[63];
    assign sign_result = result[63];

    // Check for overflow conditions
    assign overflow = (sign_A == 0 && sign_B == 1 && sign_result == 1) ||  // Positive overflow
                      (sign_A == 1 && sign_B == 0 && sign_result == 0);  // Negative overflow

endmodule