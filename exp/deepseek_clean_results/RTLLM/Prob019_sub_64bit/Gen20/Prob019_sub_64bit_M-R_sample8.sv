module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Direct subtraction - let synthesis tool optimize implementation
    assign result = A - B;

    /* Overflow occurs when:
     * 1. Subtracting negative from positive gives negative result (positive overflow)
     * 2. Subtracting positive from negative gives positive result (negative overflow)
     * Equivalent to: signs of A and B differ AND result sign differs from A
     */
    assign overflow = (A[63] != B[63]) && (result[63] != A[63]);

endmodule