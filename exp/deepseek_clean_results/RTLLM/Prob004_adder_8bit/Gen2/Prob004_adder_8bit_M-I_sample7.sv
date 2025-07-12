module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Generate and propagate signals for each bit
    wire [7:0] g, p;
    assign g = a & b;  // Generate
    assign p = a ^ b;  // Propagate

    // Carry computation (lookahead)
    wire [7:0] c;
    assign c[0] = cin;
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    
    // Second level lookahead for upper bits
    wire [3:0] g4, p4;
    assign g4[0] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]);
    assign p4[0] = p[3] & p[2] & p[1] & p[0];
    assign c[4] = g4[0] | (p4[0] & c[0]);
    
    assign c[5] = g[4] | (p[4] & c[4]);
    assign c[6] = g[5] | (p[5] & g[4]) | (p[5] & p[4] & c[4]);
    assign c[7] = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & c[4]);
    
    assign cout = g[7] | (p[7] & c[7]);

    // Sum computation
    assign sum = p ^ c;

endmodule