module sub_64bit(
    input   [63:0] A,         // First 64-bit input operand
    input   [63:0] B,         // Second 64-bit input operand
    output  [63:0] result,    // 64-bit output representing the difference of the two operands (A - B)
    output          overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

    // Perform binary subtraction of A and B to obtain the result
    assign result = A - B;

    // Check for overflow conditions by examining the sign bits of A, B, and the result
    // Positive overflow occurs when a positive number (A) is subtracted by a negative number (B) and the result is negative
    // Negative overflow occurs when a negative number (A) is subtracted by a positive number (B) and the result is positive
    assign overflow = (A[63] == 0 && B[63] == 1 && result[63] == 1) || (A[63] == 1 && B[63] == 0 && result[63] == 0);

endmodule