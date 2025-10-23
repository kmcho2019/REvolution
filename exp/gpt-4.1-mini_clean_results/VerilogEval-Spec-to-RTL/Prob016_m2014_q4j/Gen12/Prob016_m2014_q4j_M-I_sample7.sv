module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;     // propagate and generate
    wire c1, c2, c3, c4; // carry signals

    // propagate and generate
    assign p = x ^ y;   // propagate: if either bit is 1
    assign g = x & y;   // generate: if both bits are 1

    // carry look-ahead logic
    assign c1 = g[0] | (p[0] & 1'b0);                  // c0=0 initial carry in
    assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & 1'b0);
    assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & 1'b0);
    assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & 1'b0);

    // sum bits
    assign sum[0] = p[0] ^ 1'b0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;

    // overflow bit
    assign sum[4] = c4;

endmodule