module TopModule (
    input  wire [3:0] x,
    input  wire [3:0] y,
    output wire [4:0] sum
);
    wire [3:0] p, g;    // propagate and generate
    wire [4:0] c;       // carries: c[0] = 0 input carry

    assign c[0] = 1'b0;

    // Generate propagate and generate signals for each bit
    assign p = x ^ y;       // propagate
    assign g = x & y;       // generate

    // Carry look-ahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & c[1]);
    assign c[3] = g[2] | (p[2] & c[2]);
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4]   = c[4];  // final carry-out as overflow bit
endmodule