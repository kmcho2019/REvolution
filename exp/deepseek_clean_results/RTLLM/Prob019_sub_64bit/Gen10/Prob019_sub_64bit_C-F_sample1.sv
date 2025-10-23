module sub_64bit (
    input signed [63:0] A,    // First signed operand
    input signed [63:0] B,    // Second signed operand (to subtract)
    output signed [63:0] result,  // Signed result of A - B
    output overflow           // Overflow flag
);

    // Two's complement subtraction: A - B = A + ~B + 1
    wire [63:0] B_comp = ~B;
    wire [16:0] carry_chain; // Hierarchical carry (4-bit blocks)
    assign carry_chain[0] = 1'b1; // +1 for two's complement
    
    genvar i;
    generate
        for (i=0; i<64; i=i+4) begin : sub_adder
            // Process each 4-bit block
            wire [3:0] p = A[i+:4] ^ B_comp[i+:4];
            wire [3:0] g = A[i+:4] & B_comp[i+:4];
            
            // Block carry lookahead
            wire block_carry = g[3] | (p[3] & g[2]) | 
                              (p[3] & p[2] & g[1]) | 
                              (p[3] & p[2] & p[1] & g[0]) |
                              (p[3] & p[2] & p[1] & p[0] & carry_chain[i/4]);
            
            // Generate next block carry
            if (i < 60) assign carry_chain[(i/4)+1] = block_carry;
            
            // Compute results for this block
            assign result[i]   = p[0] ^ carry_chain[i/4];
            assign result[i+1] = p[1] ^ (g[0] | (p[0] & carry_chain[i/4]));
            assign result[i+2] = p[2] ^ (g[1] | (p[1] & g[0]) | 
                                (p[1] & p[0] & carry_chain[i/4]));
            assign result[i+3] = p[3] ^ (g[2] | (p[2] & g[1]) | 
                                (p[2] & p[1] & g[0]) | 
                                (p[2] & p[1] & p[0] & carry_chain[i/4]));
        end
    endgenerate

    // Shared XOR for overflow detection (uses MSB from subtraction)
    wire msb_sign_diff = A[63] ^ B[63];
    assign overflow = msb_sign_diff && (A[63] ^ result[63]);

endmodule