module TopModule(
    input [3:0] x,
    input [3:0] y,
    output [4:0] sum
);
    wire c0, c1, c2, c3, c4;
    wire g0, g1, g2, g3; // generate signals
    wire p0, p1, p2, p3; // propagate signals

    // Initial carry-in
    assign c0 = 1'b0;

    // Generate and Propagate for each bit
    assign g0 = x[0] & y[0];
    assign p0 = x[0] ^ y[0];
    assign g1 = x[1] & y[1];
    assign p1 = x[1] ^ y[1];
    assign g2 = x[2] & y[2];
    assign p2 = x[2] ^ y[2];
    assign g3 = x[3] & y[3];
    assign p3 = x[3] ^ y[3];

    // Carry ripple
    assign c1 = g0 | (p0 & c0);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign c4 = g3 | (p3 & c3);

    // Sum bits
    assign sum[0] = p0 ^ c0;
    assign sum[1] = p1 ^ c1;
    assign sum[2] = p2 ^ c2;
    assign sum[3] = p3 ^ c3;

    // Overflow bit (carry out)
    assign sum[4] = c4;
endmodule