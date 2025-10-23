module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate and Propagate signals
    wire [3:0] g = x & y;  // Generate
    wire [3:0] p = x ^ y;  // Propagate
    
    // Carry Lookahead Logic
    wire c0 = 1'b0;  // No initial carry
    wire c1 = g[0] | (p[0] & c0);
    wire c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    wire c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    wire c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | 
              (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c0);
    
    // Sum computation
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = c4;  // Overflow bit
endmodule