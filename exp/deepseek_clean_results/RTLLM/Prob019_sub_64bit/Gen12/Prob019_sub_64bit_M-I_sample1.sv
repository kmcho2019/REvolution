module sub_64bit (
    input signed [63:0] A,
    input signed [63:0] B,
    output signed [63:0] result,
    output overflow
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [63:0] carry_chain;

    // Carry-lookahead in 4-bit blocks
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : CLA_BLOCKS
            // Block propagate and generate
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            
            // Carry computation
            if (i == 0) begin
                assign carry_chain[0] = g[0] | (p[0] & 1'b1);
                assign carry_chain[1] = g[1] | (p[1] & carry_chain[0]);
                assign carry_chain[2] = g[2] | (p[2] & carry_chain[1]);
                assign carry_chain[3] = g[3] | (p[3] & carry_chain[2]);
            end else begin
                assign carry_chain[i]   = g[0] | (p[0] & carry_chain[i-1]);
                assign carry_chain[i+1] = g[1] | (p[1] & carry_chain[i]);
                assign carry_chain[i+2] = g[2] | (p[2] & carry_chain[i+1]);
                assign carry_chain[i+3] = g[3] | (p[3] & carry_chain[i+2]);
            end
            
            // Sum computation
            assign result[i]   = p[0] ^ ((i == 0) ? 1'b1 : carry_chain[i-1]);
            assign result[i+1] = p[1] ^ carry_chain[i];
            assign result[i+2] = p[2] ^ carry_chain[i+1];
            assign result[i+3] = p[3] ^ carry_chain[i+2];
        end
    endgenerate

    // Overflow detection using final carry and sign bits
    assign overflow = (A[63] ^ B[63]) && (A[63] ^ result[63]);

endmodule