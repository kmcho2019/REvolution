module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Bit-level propagate and generate
    wire [7:0] p = a ^ b;
    wire [7:0] g = a & b;

    // Group propagate and generate (4-bit groups)
    wire p0_3 = p[0] & p[1] & p[2] & p[3];
    wire g0_3 = g[3] | (g[2] & p[3]) | (g[1] & p[2] & p[3]) | (g[0] & p[1] & p[2] & p[3]);
    
    wire p4_7 = p[4] & p[5] & p[6] & p[7];
    wire g4_7 = g[7] | (g[6] & p[7]) | (g[5] & p[6] & p[7]) | (g[4] & p[5] & p[6] & p[7]);

    // Carry lookahead logic
    wire c4 = g0_3 | (p0_3 & cin);
    wire c8 = g4_7 | (p4_7 & c4);
    
    // Generate intermediate carries
    wire c1 = g[0] | (p[0] & cin);
    wire c2 = g[1] | (p[1] & c1);
    wire c3 = g[2] | (p[2] & c2);
    
    wire c5 = g[4] | (p[4] & c4);
    wire c6 = g[5] | (p[5] & c5);
    wire c7 = g[6] | (p[6] & c6);

    // Generate sums
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = p[4] ^ c4;
    assign sum[5] = p[5] ^ c5;
    assign sum[6] = p[6] ^ c6;
    assign sum[7] = p[7] ^ c7;
    
    assign cout = c8;
endmodule