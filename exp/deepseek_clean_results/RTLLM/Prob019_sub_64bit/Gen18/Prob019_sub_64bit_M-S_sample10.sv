module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Simple arithmetic subtraction
    assign result = A - B;

    // Overflow occurs when:
    // 1. A and B have different signs, and
    // 2. Result sign doesn't match A's sign
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule