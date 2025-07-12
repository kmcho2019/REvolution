module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    /////////////////////////////////////////////////
    // Subtraction Logic (A - B using carry-lookahead)
    /////////////////////////////////////////////////
    wire [63:0] B_comp = ~B;
    wire [63:0] p = A ^ B_comp;  // propagate
    wire [63:0] g = A & B_comp;  // generate
    
    // Carry chain calculation
    wire [64:0] carry;
    assign carry[0] = 1'b1;
    assign carry[64:1] = g | (p & carry[63:0]);
    
    // Final result
    assign result = p ^ carry[63:0];

    /////////////////////////////////////////////////
    // Overflow Detection
    /////////////////////////////////////////////////
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

    /* Overflow Conditions:
     * 1. Positive overflow: A positive, B negative, result negative
     * 2. Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] != B[63])
     * - Result sign differs from A (A[63] != result[63])
     */

endmodule