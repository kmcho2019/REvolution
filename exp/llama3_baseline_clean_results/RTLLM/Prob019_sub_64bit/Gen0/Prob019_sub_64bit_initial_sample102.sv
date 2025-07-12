module sub_64bit(
    input   [63:0] A,         // First 64-bit input operand
    input   [63:0] B,         // Second 64-bit input operand
    output  [63:0] result,    // 64-bit output representing the difference of the two operands
    output          overflow  // 1-bit output indicating whether an overflow occurred
);

    assign result = A - B;

    // Check for overflow conditions
    assign overflow = (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1) || 
                      (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0);

endmodule