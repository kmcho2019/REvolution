module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    /////////////////////////////////////////////////
    // Subtraction Logic (A - B using 8-bit CLA blocks)
    /////////////////////////////////////////////////
    wire [63:0] B_comp = ~B;
    wire [63:0] p = A ^ B_comp;  // propagate
    wire [63:0] g = A & B_comp;  // generate
    
    // Hierarchical 8-bit carry chain
    wire [64:0] carry;
    assign carry[0] = 1'b1;
    
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            assign carry[i+1] = g[i]   | (p[i]   & carry[i]);
            assign carry[i+2] = g[i+1] | (p[i+1] & carry[i+1]);
            assign carry[i+3] = g[i+2] | (p[i+2] & carry[i+2]);
            assign carry[i+4] = g[i+3] | (p[i+3] & carry[i+3]);
            assign carry[i+5] = g[i+4] | (p[i+4] & carry[i+4]);
            assign carry[i+6] = g[i+5] | (p[i+5] & carry[i+5]);
            assign carry[i+7] = g[i+6] | (p[i+6] & carry[i+6]);
            assign carry[i+8] = g[i+7] | (p[i+7] & carry[i+7]);
        end
    endgenerate

    // Final result
    assign result = p ^ carry[63:0];

    /////////////////////////////////////////////////
    // Overflow Detection
    /////////////////////////////////////////////////
    /* Overflow occurs when:
     * 1. Positive overflow: A positive, B negative, result negative
     * 2. Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] != B[63])
     * - Result sign differs from A (A[63] != result[63])
     */
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

endmodule