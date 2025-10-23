module TopModule(
    input [7:0] a,
    input [7:0] b,
    output [7:0] s,
    output overflow
);
    // Generate and propagate terms
    wire [7:0] g = a & b;
    wire [7:0] p = a ^ b;
    
    // First level carry-lookahead (4-bit groups)
    wire [1:0] g_group, p_group;
    wire [1:0] c_group;
    
    assign g_group[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p_group[0] = p[3] & p[2] & p[1] & p[0];
    
    assign g_group[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign p_group[1] = p[7] & p[6] & p[5] & p[4];
    
    assign c_group[0] = g_group[0];
    assign c_group[1] = g_group[1] | (p_group[1] & c_group[0]);
    
    // Second level carry computation
    wire [7:0] c;
    assign c[0] = g[0];
    assign c[1] = g[1] | (p[1] & c[0]);
    assign c[2] = g[2] | (p[2] & c[1]);
    assign c[3] = g[3] | (p[3] & c[2]);
    assign c[4] = g[4] | (p[4] & c_group[0]);
    assign c[5] = g[5] | (p[5] & c[4]);
    assign c[6] = g[6] | (p[6] & c[5]);
    assign c[7] = g[7] | (p[7] & c[6]);
    
    // Sum computation
    assign s = p ^ {c[6:0], 1'b0};
    
    // Optimized overflow detection
    assign overflow = (a[7] & b[7] & ~s[7]) | (~a[7] & ~b[7] & s[7]);
endmodule