module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output wire signed [63:0] result,
    output wire overflow
);

    // Direct subtraction using Verilog arithmetic
    assign result = A - B;

    // Overflow detection signals
    wire A_positive = ~A[63];  // A is positive
    wire B_negative = B[63];    // B is negative
    wire result_negative = result[63];
    
    wire A_negative = A[63];    // A is negative
    wire B_positive = ~B[63];   // B is positive
    wire result_positive = ~result[63];

    // Overflow occurs when:
    // 1. Positive - Negative = Negative (positive overflow)
    // 2. Negative - Positive = Positive (negative overflow)
    assign overflow = (A_positive & B_negative & result_negative) |
                     (A_negative & B_positive & result_positive);

    /* Alternative implementation using single expression:
     * assign overflow = (A[63] != B[63]) && (A[63] != result[63]);
     * This is equivalent but less readable
     */

endmodule