module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p; // propagate signals
    wire [3:0] g; // generate signals
    wire [4:0] c; // carry signals (c[0] is initial carry-in)
    wire [3:0] xor_xy; // xor of x and y for sum bits

    assign p = x ^ y;      // propagate = x XOR y
    assign g = x & y;      // generate = x AND y

    assign c[0] = 1'b0;    // initial carry-in

    // Carry lookahead logic
    assign c[1] = g[0] | (p[0] & c[0]);
    assign c[2] = g[1] | (p[1] & g[0]) | (p[1] & p[0] & c[0]);
    assign c[3] = g[2] | (p[2] & g[1]) | (p[2] & p[1] & g[0]) | (p[2] & p[1] & p[0] & c[0]);
    assign c[4] = g[3] | (p[3] & g[2]) | (p[3] & p[2] & g[1]) | (p[3] & p[2] & p[1] & g[0]) | 
                  (p[3] & p[2] & p[1] & p[0] & c[0]);

    assign sum[4] = c[4]; // overflow bit

    assign xor_xy = p;    // since p = x ^ y

    // sum bits calculation: sum[i] = p[i] ^ c[i]
    assign sum[3:0] = xor_xy ^ c[3:0];

endmodule