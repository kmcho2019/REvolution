module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Simple two's complement subtraction
    assign result = A - B;

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Simplified implementation using bit extension comparison
     */
    wire [64:0] extended_result = {A[63], A} - {B[63], B};
    assign overflow = (extended_result[64] != extended_result[63]);

endmodule