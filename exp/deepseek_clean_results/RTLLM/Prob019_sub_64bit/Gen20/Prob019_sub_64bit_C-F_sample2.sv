module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Optimized 8-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [7:0] p = A[i+:8] ^ B_comp[i+:8];
            wire [7:0] g = A[i+:8] & B_comp[i+:8];
            
            // Direct carry computation (optimized)
            assign carry[i]   = g[0] | (p[0] & ((i == 0) ? 1'b1 : carry[i-1]));
            assign carry[i+1] = g[1] | (p[1] & carry[i]);
            assign carry[i+2] = g[2] | (p[2] & carry[i+1]);
            assign carry[i+3] = g[3] | (p[3] & carry[i+2]);
            assign carry[i+4] = g[4] | (p[4] & carry[i+3]);
            assign carry[i+5] = g[5] | (p[5] & carry[i+4]);
            assign carry[i+6] = g[6] | (p[6] & carry[i+5]);
            assign carry[i+7] = g[7] | (p[7] & carry[i+6]);
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
            assign result[i+1] = p[1] ^ carry[i];
            assign result[i+2] = p[2] ^ carry[i+1];
            assign result[i+3] = p[3] ^ carry[i+2];
            assign result[i+4] = p[4] ^ carry[i+3];
            assign result[i+5] = p[5] ^ carry[i+4];
            assign result[i+6] = p[6] ^ carry[i+5];
            assign result[i+7] = p[7] ^ carry[i+6];
        end
    endgenerate

    /* Overflow detection:
     * Positive overflow: A positive, B negative → result negative
     * Negative overflow: A negative, B positive → result positive
     * Simplified to: (A[63] ^ B[63]) && (A[63] ^ result[63])
     */
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule