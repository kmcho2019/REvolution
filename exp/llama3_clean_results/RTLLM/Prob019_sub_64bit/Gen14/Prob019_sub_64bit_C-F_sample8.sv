module sub_64bit(
    input  wire [63:0] A,  // First 64-bit input operand
    input  wire [63:0] B,  // Second 64-bit input operand
    output wire [63:0] result,  // 64-bit output representing the difference of A and B
    output wire        overflow  // 1-bit output indicating whether an overflow occurred
);

    // Perform binary subtraction of A and B
    assign result = A - B;
    
    // Simplified overflow detection logic
    // An overflow occurs when A and B have the same sign but the result has a different sign
    assign overflow = (A[63] == B[63] && A[63] != result[63]);

endmodule