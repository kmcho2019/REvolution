module sub_64bit(
    input   [63:0] A,  // First 64-bit input operand
    input   [63:0] B,  // Second 64-bit input operand
    output  [63:0] result,  // 64-bit output representing the difference
    output         overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform the binary subtraction of A and B
    assign result = A - B;

    // Determine the sign bits of A, B, and the result
    wire sign_A = A[63];
    wire sign_B = B[63];
    wire sign_result = result[63];

    // Check for overflow conditions
    assign overflow = (sign_A == 0 && sign_B == 1 && sign_result == 1) || 
                      (sign_A == 1 && sign_B == 0 && sign_result == 0);

endmodule