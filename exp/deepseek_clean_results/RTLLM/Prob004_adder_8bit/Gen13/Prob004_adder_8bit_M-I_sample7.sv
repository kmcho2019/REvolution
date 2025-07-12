module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);

    // Propagate and Generate signals for each bit
    wire [7:0] p = a ^ b;  // Propagate
    wire [7:0] g = a & b;  // Generate

    // Carry computation with optimized structure
    wire c0 = g[0] | (p[0] & cin);
    wire c1 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & cin);
    wire c2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & cin);
    wire c3 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
              (p[3] & p[2] & p[1] & p[0] & cin);
    
    // Optimized upper bits carry computation
    wire c4 = g[4] | (p[4] & c3);
    wire c5 = g[5] | (p[5] & c4);
    wire c6 = g[6] | (p[6] & c5);
    wire c7 = g[7] | (p[7] & c6);

    // Sum computation
    assign sum[0] = p[0] ^ cin;
    assign sum[1] = p[1] ^ c0;
    assign sum[2] = p[2] ^ c1;
    assign sum[3] = p[3] ^ c2;
    assign sum[4] = p[4] ^ c3;
    assign sum[5] = p[5] ^ c4;
    assign sum[6] = p[6] ^ c5;
    assign sum[7] = p[7] ^ c6;

    // Final carry out
    assign cout = c7;

endmodule