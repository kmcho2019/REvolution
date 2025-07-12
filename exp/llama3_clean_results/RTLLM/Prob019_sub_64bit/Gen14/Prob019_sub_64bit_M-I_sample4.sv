module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction of A and B
    assign result = A - B;
    
    // Optimized overflow detection logic
    // An overflow occurs when the result of the subtraction has a different sign than the maximum of A and B
    assign overflow = (A[63] == B[63] && A[63] != result[63]) ? 1'b1 : 1'b0;

    // Alternatively, we can use a more efficient method for detecting overflows
    // assign overflow = (A[63] == 1'b1 && B[63] == 1'b0 && result[63] == 1'b0) || (A[63] == 1'b0 && B[63] == 1'b1 && result[63] == 1'b1);

endmodule