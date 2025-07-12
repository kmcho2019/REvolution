module sub_64bit(
    input [63:0] A,  // First 64-bit input operand
    input [63:0] B,  // Second 64-bit input operand
    output [63:0] result,  // 64-bit output representing the difference of the two operands (A - B)
    output reg overflow  // 1-bit output indicating whether an overflow occurred during the subtraction operation
);

    // Perform binary subtraction of A and B
    assign result = A - B;

    // Simplified overflow detection logic
    always @(*) overflow = (A[63] != B[63]) && (A[63] != result[63]) ? 1'b1 : 1'b0;

endmodule