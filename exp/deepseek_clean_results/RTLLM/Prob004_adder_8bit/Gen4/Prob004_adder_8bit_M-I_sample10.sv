module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate and Propagate signals for each bit
    wire [7:0] g, p;
    wire [1:0] gg, gp;  // Group generate/propagate
    wire [1:0] c;       // Group carries

    // Bit-level generate and propagate
    assign g = a & b;
    assign p = a ^ b;

    // First 4-bit group
    assign gg[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign gp[0] = p[3] & p[2] & p[1] & p[0];
    assign c[0] = g[0] | (p[0] & cin);
    assign c[1] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    assign c[2] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    
    // Second 4-bit group
    assign gg[1] = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | (p[7] & p[6] & p[5] & g[4]);
    assign gp[1] = p[7] & p[6] & p[5] & p[4];
    
    // Group carry computation
    wire cout_grp0 = gg[0] | (gp[0] & cin);
    wire cout_grp1 = gg[1] | (gp[1] & cout_grp0);
    
    // Sum computation
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c[0];
    assign sum[2] = p[2] ^ c[1];
    assign sum[3] = p[3] ^ c[2];
    assign sum[4] = p[4] ^ cout_grp0;
    assign sum[5] = p[5] ^ (g[4] | (p[4] & cout_grp0));
    assign sum[6] = p[6] ^ (g[5] | (p[5] & g[4]) | (p[5] & p[4] & cout_grp0));
    assign sum[7] = p[7] ^ (g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & cout_grp0));
    
    assign cout = cout_grp1;

endmodule