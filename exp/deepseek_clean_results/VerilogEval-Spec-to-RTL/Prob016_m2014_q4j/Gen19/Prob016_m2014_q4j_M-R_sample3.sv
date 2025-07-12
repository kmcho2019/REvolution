module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire [3:0] p = x ^ y;  // propagate
    wire [3:0] g = x & y;  // generate
    
    // Carry chain
    wire c0 = g[0] | (p[0] & 1'b0);
    wire c1 = g[1] | (p[1] & c0);
    wire c2 = g[2] | (p[2] & c1);
    
    // Sum calculations
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c0;
    assign sum[2] = p[2] ^ c1;
    assign sum[3] = p[3] ^ c2;
    
    // Final carry (sum[4])
    assign sum[4] = g[3] | (p[3] & c2);
endmodule