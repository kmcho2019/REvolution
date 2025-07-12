module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;      // propagate and generate
    wire [4:0] c;         // carry signals, c[0] = 0 input carry

    assign c[0] = 1'b0;   // initial carry-in

    // Propagate and generate signals
    assign p = x ^ y;     // propagate: if either input bit is 1 (but not both)
    assign g = x & y;     // generate: if both bits are 1, generate carry

    // Carry-lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum bits calculation
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4] = c[4];  // overflow bit

endmodule