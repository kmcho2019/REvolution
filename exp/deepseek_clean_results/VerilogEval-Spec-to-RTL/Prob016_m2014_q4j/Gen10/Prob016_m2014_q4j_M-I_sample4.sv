module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    // Generate and propagate signals
    wire [3:0] g = x & y;  // Generate
    wire [3:0] p = x ^ y;  // Propagate

    // Carry lookahead logic
    wire [3:0] c;
    assign c[0] = 1'b0;  // No carry in
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);

    // Sum computation
    assign sum[0] = p[0] ^ c[0];
    assign sum[1] = p[1] ^ c[1];
    assign sum[2] = p[2] ^ c[2];
    assign sum[3] = p[3] ^ c[3];
    assign sum[4] = g[3] | (p[3] & c[3]);  // Final carry out
endmodule