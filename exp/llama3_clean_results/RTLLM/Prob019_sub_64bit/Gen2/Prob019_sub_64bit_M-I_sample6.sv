module sub_64bit (
    input   [63:0] A,  // First 64-bit input operand
    input   [63:0] B,  // Second 64-bit input operand
    output  [63:0] result,  // 64-bit output representing the difference of the two operands (A - B)
    output         overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Check for overflow conditions by examining the sign bits of A, B, and the result
    // The sign bit of a 64-bit signed integer is the most significant bit (MSB), which is bit 63
    // Using a slightly rearranged logic for potential minor optimization
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) ||  // Positive overflow
                     (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);  // Negative overflow

    // Additional optimization: Considering the use of synthesis tool directives
    // to further optimize area and power consumption, if applicable.

endmodule