module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain;

    // Hierarchical 4-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            
            // Carry computation (optimized hierarchical)
            wire [3:0] carry;
            assign carry[0] = g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]));
            assign carry[1] = g[1] | (p[1] & carry[0]);
            assign carry[2] = g[2] | (p[2] & carry[1]);
            assign carry[3] = g[3] | (p[3] & carry[2]);
            
            // Store carries for next block
            assign carry_chain[i]   = carry[0];
            assign carry_chain[i+1] = carry[1];
            assign carry_chain[i+2] = carry[2];
            assign carry_chain[i+3] = carry[3];
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry_chain[i-1]);
            assign result[i+1] = p[1] ^ carry[0];
            assign result[i+2] = p[2] ^ carry[1];
            assign result[i+3] = p[3] ^ carry[2];
        end
    endgenerate

    // Efficient overflow detection
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule