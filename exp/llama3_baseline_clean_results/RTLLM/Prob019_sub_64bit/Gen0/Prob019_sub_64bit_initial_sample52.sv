module sub_64bit(
    input   [63:0] A,         // 64-bit input operand A
    input   [63:0] B,         // 64-bit input operand B
    output  [63:0] result,    // 64-bit output result (A - B)
    output         overflow   // 1-bit output overflow flag
);

    // Calculate the result of A - B
    assign result = A - B;

    // Determine the sign of A, B, and the result
    wire sign_A = A[63];      // Sign bit of A (0 for positive, 1 for negative)
    wire sign_B = B[63];      // Sign bit of B (0 for positive, 1 for negative)
    wire sign_result = result[63];  // Sign bit of the result (0 for positive, 1 for negative)

    // Check for overflow conditions
    // Positive overflow: A is positive, B is negative, and the result is negative
    // Negative overflow: A is negative, B is positive, and the result is positive
    assign overflow = (sign_A == 1'b0 && sign_B == 1'b1 && sign_result == 1'b1) ||
                      (sign_A == 1'b1 && sign_B == 1'b0 && sign_result == 1'b0);

endmodule