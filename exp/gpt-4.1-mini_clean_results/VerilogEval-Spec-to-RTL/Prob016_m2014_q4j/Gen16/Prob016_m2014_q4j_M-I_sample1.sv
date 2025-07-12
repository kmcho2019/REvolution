module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g, p;
    wire [4:0] c;

    assign c[0] = 1'b0;           // initial carry-in

    // generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // carry-lookahead logic - fully expanded for 4 bits
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // sum bits computed directly from propagate and carry-in
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4] = c[4];         // final carry-out (overflow)

endmodule