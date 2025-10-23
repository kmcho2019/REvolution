module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction implementation
    assign result = A - B;

    /* Overflow Detection:
     * Positive overflow: A positive, B negative, result negative
     * Negative overflow: A negative, B positive, result positive
     * Simplified to one expression using sign bits
     */
    assign overflow = (~A[63] & B[63] & result[63]) |  // Positive overflow
                     (A[63] & ~B[63] & ~result[63]);   // Negative overflow

    /* Implementation Notes:
     * 1. Subtraction implemented directly using Verilog operator
     * 2. Overflow detection uses same logic but more readable expression
     * 3. Synthesis tools will optimize the implementation
     * 4. More maintainable and easier to understand
     */
endmodule