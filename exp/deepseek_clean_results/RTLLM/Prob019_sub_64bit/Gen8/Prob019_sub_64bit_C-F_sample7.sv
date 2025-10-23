module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Signed subtraction operation
    assign result = A - B;
    
    // Overflow occurs when:
    // 1. Operands have opposite signs, and
    // 2. Result sign differs from first operand
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule