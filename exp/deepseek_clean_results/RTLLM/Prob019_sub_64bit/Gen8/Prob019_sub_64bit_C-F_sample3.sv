module sub_64bit (
    input signed [63:0] A,    // First signed operand
    input signed [63:0] B,    // Second signed operand (to subtract)
    output signed [63:0] result,  // Signed result of A - B
    output overflow           // Overflow flag
);

    // Perform signed subtraction
    wire signed [63:0] diff = A - B;
    
    // Overflow occurs when:
    // 1. Operands have different signs (A positive & B negative or vice versa)
    // 2. Result sign differs from A's sign
    wire operands_diff_sign = A[63] != B[63];
    wire result_diff_sign = diff[63] != A[63];
    
    // Assign outputs
    assign result = diff;
    assign overflow = operands_diff_sign && result_diff_sign;

endmodule