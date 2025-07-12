module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Hierarchical 4-bit carry-lookahead blocks
    wire [1:0] g_block, p_block;
    wire [1:0] c_block;
    
    // First 4-bit block (bits 3:0)
    wire [3:0] g0 = a[3:0] & b[3:0];
    wire [3:0] p0 = a[3:0] ^ b[3:0];
    wire [3:0] c0;
    
    assign c0[0] = g0[0];
    assign c0[1] = g0[1] | (p0[1] & c0[0]);
    assign c0[2] = g0[2] | (p0[2] & c0[1]);
    assign c0[3] = g0[3] | (p0[3] & c0[2]);
    
    // Second 4-bit block (bits 7:4)
    wire [3:0] g1 = a[7:4] & b[7:4];
    wire [3:0] p1 = a[7:4] ^ b[7:4];
    wire [3:0] c1;
    
    // Block generate/propagate
    assign g_block[0] = g0[3] | (p0[3] & (g0[2] | (p0[2] & (g0[1] | (p0[1] & g0[0]))));
    assign p_block[0] = &p0;
    assign g_block[1] = g1[3] | (p1[3] & (g1[2] | (p1[2] & (g1[1] | (p1[1] & g1[0]))));
    assign p_block[1] = &p1;
    
    // Block carry computation
    assign c_block[0] = g_block[0];
    assign c_block[1] = g_block[1] | (p_block[1] & c_block[0]);
    
    // Final carry computation
    assign c1[0] = g1[0] | (p1[0] & c_block[0]);
    assign c1[1] = g1[1] | (p1[1] & c1[0]);
    assign c1[2] = g1[2] | (p1[2] & c1[1]);
    assign c1[3] = g1[3] | (p1[3] & c1[2]);
    
    // Sum computation
    assign s[3:0] = p0 ^ {c0[2:0], 1'b0};
    assign s[7:4] = p1 ^ {c1[2:0], c_block[0]};
    
    // Optimized overflow detection
    wire signs_differ = a[7] ^ b[7];
    assign overflow = ~signs_differ & (a[7] ^ s[7]);
endmodule