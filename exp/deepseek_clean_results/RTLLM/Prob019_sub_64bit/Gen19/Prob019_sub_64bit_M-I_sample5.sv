module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    /////////////////////////////////////////////////
    // Hierarchical 4-bit Carry-Lookahead Adder
    /////////////////////////////////////////////////
    wire [63:0] B_comp = ~B;
    wire [15:0][3:0] p, g;  // 16 groups of 4-bit propagate/generate
    wire [15:0] P, G;       // Group propagate/generate
    wire [16:0] carry;      // Group carries
    
    // Generate propagate and generate for each 4-bit block
    genvar i;
    generate
        for (i = 0; i < 16; i = i + 1) begin : CLA_BLOCKS
            assign p[i] = A[i*4+3:i*4] ^ B_comp[i*4+3:i*4];
            assign g[i] = A[i*4+3:i*4] & B_comp[i*4+3:i*4];
            
            // Block propagate and generate
            assign P[i] = &p[i];
            assign G[i] = |(g[i] & {4{1'b1}});
            
            // Carry for next block
            assign carry[i+1] = G[i] | (P[i] & carry[i]);
            
            // Final sum for this block
            assign result[i*4+3:i*4] = p[i] ^ {carry[i], carry[i], carry[i], carry[i]};
        end
    endgenerate
    
    assign carry[0] = 1'b1;  // Initial carry-in for subtraction

    /////////////////////////////////////////////////
    // Optimized Overflow Detection
    /////////////////////////////////////////////////
    assign overflow = (A[63] ^ B[63]) & (A[63] ^ result[63]);

    /* Overflow Conditions:
     * 1. Positive overflow: A positive, B negative, result negative
     * 2. Negative overflow: A negative, B positive, result positive
     * Detected when:
     * - Signs of A and B differ (A[63] ^ B[63])
     * - Result sign differs from A (A[63] ^ result[63])
     */

endmodule