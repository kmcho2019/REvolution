module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate Propagate and Generate signals
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Carry-lookahead logic
    wire [7:0] c;
    assign c[0] = cin;
    
    // First level carry computation
    wire [3:0] g_level1, p_level1;
    assign g_level1[0] = g[0] | (p[0] & cin);
    assign p_level1[0] = p[0];
    
    assign g_level1[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign p_level1[1] = p[1] & p[0];
    
    assign g_level1[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    assign p_level1[2] = p[2] & p[1] & p[0];
    
    assign g_level1[3] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & cin);
    assign p_level1[3] = p[3] & p[2] & p[1] & p[0];
    
    // Second level carry computation
    wire [1:0] g_level2, p_level2;
    assign g_level2[0] = g_level1[0];
    assign p_level2[0] = p_level1[0];
    
    assign g_level2[1] = g_level1[1] | (p_level1[1] & g_level1[0]);
    assign p_level2[1] = p_level1[1] & p_level1[0];
    
    // Final carry computation
    assign c[1] = g_level1[0] | (p_level1[0] & cin);
    assign c[2] = g_level1[1] | (p_level1[1] & c[1]);
    assign c[3] = g_level1[2] | (p_level1[2] & c[2]);
    assign c[4] = g_level1[3] | (p_level1[3] & c[3]);
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & c[5]);
    assign c[7] = g[6] | (p[6] & c[6]);
    assign cout = g[7] | (p[7] & c[7]);

    // Sum computation
    assign sum = p ^ {c[6:0], cin};

endmodule