module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    /////////////////////////////////////////////////
    // Optimized Subtraction Logic
    /////////////////////////////////////////////////
    wire [63:0] B_comp = ~B;
    wire [63:0] carry;

    // Hierarchical 4-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            
            // Carry computation (optimized first block handling)
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
            
            // Sum computation with optimized first bit handling
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry[i-1]);
            assign result[i+1] = p[1] ^ carry[i];
            assign result[i+2] = p[2] ^ carry[i+1];
            assign result[i+3] = p[3] ^ carry[i+2];
        end
    endgenerate

    /////////////////////////////////////////////////
    // Efficient Overflow Detection
    /////////////////////////////////////////////////
    assign overflow = (A[63] != B[63]) && (A[63] != result[63]);

    /* Overflow Condition Explanation:
     * Positive Overflow: A >=0, B <0 → Result <0 (should be positive)
     * Negative Overflow: A <0, B >=0 → Result >=0 (should be negative)
     * Detected when:
     * 1. A and B have opposite signs (A[63] != B[63])
     * 2. Result sign differs from A's sign (A[63] != result[63])
     */

endmodule