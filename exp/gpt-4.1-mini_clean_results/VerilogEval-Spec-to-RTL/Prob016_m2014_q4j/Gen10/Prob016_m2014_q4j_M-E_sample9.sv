module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;    // propagate and generate
    wire c0, c1, c2, c3, c4; // carry signals

    // propagate and generate signals
    assign p = x ^ y;    // propagate = XOR
    assign g = x & y;    // generate = AND

    // carry lookahead logic
    assign c0 = 1'b0;    // initial carry-in is 0
    assign c1 = g[0] | (p[0] & c0);
    assign c2 = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c0);
    assign c3 = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c0);
    assign c4 = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0])
              | (p[3] & p[2] & p[1] & p[0] & c0);

    // sum bits = propagate XOR carry-in
    assign sum[0] = p[0] ^ c0;
    assign sum[1] = p[1] ^ c1;
    assign sum[2] = p[2] ^ c2;
    assign sum[3] = p[3] ^ c3;
    assign sum[4] = c4;  // overflow bit

endmodule