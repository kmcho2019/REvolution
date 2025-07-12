module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] g; // generate
    wire [3:0] p; // propagate
    wire [4:0] c; // carry signals

    assign c[0] = 1'b0; // carry-in

    // Generate and propagate signals
    assign g = x & y;
    assign p = x ^ y;

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) 
                  | (p[3] & p[2] & p[1] & p[0] & c[0]);

    // Sum bits
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4] = c[4];  // overflow bit

endmodule