module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction implementation
    assign result = A - B;

    /* Overflow Detection:
     * Occurs when:
     * 1. A and B have different signs (A[63] ^ B[63])
     * 2. Result sign differs from A's sign (A[63] ^ result[63])
     */
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

endmodule