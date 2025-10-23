module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire carry_in = 1'b1;  // +1 for two's complement

    // Hierarchical 4-bit CLA blocks with optimized carry
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : CLA_BLOCKS
            // Current block signals
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            wire [3:0] carry;
            
            // Carry computation (optimized)
            assign carry[0] = g[0] | (p[0] & ((i == 0) ? carry_in : carry[i-1]));
            assign carry[1] = g[1] | (p[1] & carry[0]);
            assign carry[2] = g[2] | (p[2] & carry[1]);
            assign carry[3] = g[3] | (p[3] & carry[2]);
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? carry_in : carry[i-1]);
            assign result[i+1] = p[1] ^ carry[0];
            assign result[i+2] = p[2] ^ carry[1];
            assign result[i+3] = p[3] ^ carry[2];
        end
    endgenerate

    /* Overflow Detection:
     * Positive overflow: A +, B -, result -
     * Negative overflow: A -, B +, result +
     * Detected when: (A sign ≠ B sign) AND (A sign ≠ result sign)
     */
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule