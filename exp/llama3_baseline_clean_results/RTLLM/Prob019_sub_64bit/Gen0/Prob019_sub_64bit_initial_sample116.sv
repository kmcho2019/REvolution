module sub_64bit(
    input [63:0] A,  // First 64-bit input operand
    input [63:0] B,  // Second 64-bit input operand
    output [63:0] result,  // 64-bit output representing the difference
    output overflow  // 1-bit output indicating overflow
);

    // Perform binary subtraction
    assign result = A - B;

    // Detect overflow conditions
    assign overflow = ((A[63] == 0) && (B[63] == 1) && (result[63] == 1)) || 
                      ((A[63] == 1) && (B[63] == 0) && (result[63] == 0));

endmodule