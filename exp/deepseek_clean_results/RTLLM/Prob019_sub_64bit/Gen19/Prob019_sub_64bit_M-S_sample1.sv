module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Perform subtraction directly
    assign result = A - B;

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] != B[63])
     * - Result sign differs from A (A[63] != result[63])
     */
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule