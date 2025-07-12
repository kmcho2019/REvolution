module sub_64bit(
    input   wire [63:0] A,       // 64-bit input operand A
    input   wire [63:0] B,       // 64-bit input operand B
    output  wire [63:0] result,  // 64-bit result of subtraction
    output  wire        overflow // 1-bit overflow flag
);

    // Perform 64-bit subtraction
    assign result = A - B;

    // Detect overflow conditions based on sign bits of A, B, and result
    assign overflow = ((A[63] == 0 && B[63] == 1 && result[63] == 1) ||  // Positive overflow
                       (A[63] == 1 && B[63] == 0 && result[63] == 0));  // Negative overflow

endmodule