module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    // Generate signals for carry-lookahead
    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;

    assign g0 = x[0] & y[0];
    assign g1 = x[1] & y[1];
    assign g2 = x[2] & y[2];
    assign g3 = x[3] & y[3];

    assign p0 = x[0] | y[0];
    assign p1 = x[1] | y[1];
    assign p2 = x[2] | y[2];
    assign p3 = x[3] | y[3];

    // Calculate carry signals using prefix tree
    wire c1, c2, c3, c4;
    assign c1 = g0;
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign c4 = g3 | (p3 & c3);

    // Generate sum bits
    assign sum[0] = x[0] ^ y[0];
    assign sum[1] = x[1] ^ y[1] ^ c1;
    assign sum[2] = x[2] ^ y[2] ^ c2;
    assign sum[3] = x[3] ^ y[3] ^ c3;

    // Overflow bit
    assign sum[4] = c4;

endmodule