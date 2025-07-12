module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // Group generate/propagate for 2-bit blocks
    wire [3:0] G, P;
    assign G[0] = g[1] | (p[1] & g[0]);
    assign P[0] = p[1] & p[0];
    assign G[1] = g[3] | (p[3] & g[2]);
    assign P[1] = p[3] & p[2];
    assign G[2] = g[5] | (p[5] & g[4]);
    assign P[2] = p[5] & p[4];
    assign G[3] = g[7] | (p[7] & g[6]);
    assign P[3] = p[7] & p[6];
    
    // Hierarchical carry computation using 2-bit blocks
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = G[0];
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = G[1] | (P[1] & c[1]);
    assign c[4] = g[4] | (p[4] & c[3]);
    assign c[5] = G[2] | (P[2] & c[3]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = G[3] | (P[3] & c[5]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Overflow detection (computed in parallel)
    wire msb_carry = c[7];
    wire msb_g = g[7];
    wire msb_p = p[7];
    assign overflow = (msb_g & ~msb_p) | (msb_carry & msb_p);
endmodule