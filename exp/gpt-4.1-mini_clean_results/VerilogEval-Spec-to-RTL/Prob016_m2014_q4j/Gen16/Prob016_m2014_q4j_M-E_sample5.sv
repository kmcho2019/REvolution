module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire [3:0] p, g;      // propagate and generate signals
    wire [4:0] c;         // carries

    // Generate propagate and generate for each bit
    assign p = x ^ y;     // propagate = a xor b
    assign g = x & y;     // generate = a and b

    assign c[0] = 1'b0;   // carry-in to LSB is 0

    // Carry-lookahead logic:
    // c1 = g0 + p0*c0
    assign c[1] = g[0] | (p[0] & c[0]);
    // c2 = g1 + p1*c1
    assign c[2] = g[1] | (p[1] & c[1]);
    // c3 = g2 + p2*c2
    assign c[3] = g[2] | (p[2] & c[2]);
    // c4 = g3 + p3*c3 (overflow carry out)
    assign c[4] = g[3] | (p[3] & c[3]);

    // Sum bits: sum[i] = p[i] xor carry[i]
    assign sum[3:0] = p ^ c[3:0];
    assign sum[4] = c[4]; // overflow bit
endmodule