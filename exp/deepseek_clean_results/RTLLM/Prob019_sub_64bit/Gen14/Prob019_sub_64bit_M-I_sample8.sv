module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain;
    wire [7:0] group_p, group_g;
    wire [7:0] block_carry;

    // Special case handling for power optimization
    wire trivial_case = (A == 0) || (B == 0);

    // 8-bit carry-lookahead blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+8) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [7:0] p = A[i+:8] ^ B_comp[i+:8];
            wire [7:0] g = A[i+:8] & B_comp[i+:8];
            
            // Group propagate/generate for hierarchical CLA
            assign group_p[i/8] = &p;
            assign group_g[i/8] = |(g & {8{1'b1}});
            
            // Carry computation
            if (i == 0) begin
                assign block_carry[0] = g[0] | (p[0] & 1'b1);
                assign carry_chain[0] = trivial_case ? 1'b0 : block_carry[0];
            end else begin
                assign block_carry[i/8] = group_g[i/8] | (group_p[i/8] & block_carry[(i/8)-1]);
                assign carry_chain[i] = trivial_case ? 1'b0 : block_carry[i/8];
            end
            
            // Sum computation with shared logic
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry_chain[i-1]);
            assign result[i+1] = p[1] ^ (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1])));
            assign result[i+2] = p[2] ^ (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]))));
            assign result[i+3] = p[3] ^ (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]))))));
            assign result[i+4] = p[4] ^ (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1])))))))));
            assign result[i+5] = p[5] ^ (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]))))))))));
            assign result[i+6] = p[6] ^ (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1]))))))))))));
            assign result[i+7] = p[7] ^ (g[6] | (p[6] & (g[5] | (p[5] & (g[4] | (p[4] & (g[3] | (p[3] & (g[2] | (p[2] & (g[1] | (p[1] & (g[0] | (p[0] & ((i == 0) ? 1'b1 : carry_chain[i-1])))))))))))));
        end
    endgenerate

    // Efficient overflow detection using final carry and sign bits
    assign overflow = trivial_case ? 1'b0 : ((A[63] ^ B[63]) && (A[63] ^ result[63]));

endmodule