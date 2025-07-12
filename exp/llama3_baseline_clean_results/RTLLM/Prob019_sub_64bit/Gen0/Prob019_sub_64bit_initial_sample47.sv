module sub_64bit(
    input   [63:0] A,      // First 64-bit input operand
    input   [63:0] B,      // Second 64-bit input operand
    output  [63:0] result, // 64-bit output representing the difference of the two operands
    output          overflow // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction
    assign result = A - B;

    // Check for overflow conditions
    // Positive overflow occurs when a positive number (A) is subtracted by a negative number (B) and the result is negative
    // Negative overflow occurs when a negative number (A) is subtracted by a positive number (B) and the result is positive
    assign overflow = ((~A[63] & B[63] & result[63]) | (A[63] & ~B[63] & ~result[63]));

endmodule