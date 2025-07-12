module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    /////////////////////////////////////////////////
    // Subtraction Logic with Hierarchical CLA
    /////////////////////////////////////////////////
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // 4-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            
            // Carry computation
            if (i == 0) begin
                assign carry[0] = g[0] | (p[0] & 1'b1);
                assign carry[1] = g[1] | (p[1] & carry[0]);
                assign carry[2] = g[2] | (p[2] & carry[1]);
                assign carry[3] = g[3] | (p[3] & carry[2]);
            end else begin
                assign carry[i]   = g[0] | (p[0] & carry[i-1]);
                assign carry[i+1] = g[1] | (p[1] & carry[i]);
                assign carry[i+2] = g[2] | (p[2] & carry[i+1]);
                assign carry[i+3] = g[3] | (p[3] & carry[i+2]);
            end
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
            assign result[i+1] = p[1] ^ carry[i];
            assign result[i+2] = p[2] ^ carry[i+1];
            assign result[i+3] = p[3] ^ carry[i+2];
        end
    endgenerate

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