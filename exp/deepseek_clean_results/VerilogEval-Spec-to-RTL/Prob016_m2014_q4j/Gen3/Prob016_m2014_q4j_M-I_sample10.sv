module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate and propagate signals
    wire [3:0] p = x ^ y;
    wire [3:0] g = x & y;
    
    // Optimized carry computation with shared subexpressions
    wire p0p1 = p[0] & p[1];
    wire p0p1p2 = p0p1 & p[2];
    
    wire c0 = g[0];
    wire c1 = g[1] | (p[1] & g[0]);
    wire c2 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]);
    wire c3 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p0p1p2 & g[0]);
    
    // Direct sum computation (optimized full adder logic inlined)
    assign sum[0] = p[0];
    assign sum[1] = p[1] ^ c0;
    assign sum[2] = p[2] ^ c1;
    assign sum[3] = p[3] ^ c2;
    assign sum[4] = c3;
endmodule