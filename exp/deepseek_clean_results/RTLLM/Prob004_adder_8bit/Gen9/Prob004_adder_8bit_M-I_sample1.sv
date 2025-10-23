module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Carry generate and propagate signals
    wire [7:0] g = a & b;  // Generate
    wire [7:0] p = a | b;  // Propagate
    
    // Carry computation (4-bit lookahead blocks)
    wire c4;
    
    // First 4-bit block
    wire c0 = cin;
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
               (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);
    
    // Second 4-bit block
    wire c5 = g[4] | (p[4] & c4);
    wire c6 = g[5] | (p[5] & g[4]) | (p[5] & p[4] & c4);
    wire c7 = g[6] | (p[6] & g[5]) | (p[6] & p[5] & g[4]) | (p[6] & p[5] & p[4] & c4);
    assign cout = g[7] | (p[7] & g[6]) | (p[7] & p[6] & g[5]) | 
                 (p[7] & p[6] & p[5] & g[4]) | (p[7] & p[6] & p[5] & p[4] & c4);
    
    // Sum computation
    assign sum[0] = a[0] ^ b[0] ^ c0;
    assign sum[1] = a[1] ^ b[1] ^ c1;
    assign sum[2] = a[2] ^ b[2] ^ c2;
    assign sum[3] = a[3] ^ b[3] ^ c3;
    assign sum[4] = a[4] ^ b[4] ^ c4;
    assign sum[5] = a[5] ^ b[5] ^ c5;
    assign sum[6] = a[6] ^ b[6] ^ c6;
    assign sum[7] = a[7] ^ b[7] ^ c7;

endmodule