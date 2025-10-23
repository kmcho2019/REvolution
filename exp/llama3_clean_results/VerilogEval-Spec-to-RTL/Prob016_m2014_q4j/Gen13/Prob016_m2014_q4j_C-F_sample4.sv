module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;
    wire c1, c2, c3, c4;

    assign g0 = x[0] & y[0];
    assign p0 = x[0] ^ y[0];
    assign g1 = x[1] & y[1];
    assign p1 = x[1] ^ y[1];
    assign g2 = x[2] & y[2];
    assign p2 = x[2] ^ y[2];
    assign g3 = x[3] & y[3];
    assign p3 = x[3] ^ y[3];

    assign c1 = g0 | (p0 & 1'b0);
    assign c2 = g1 | (p1 & c1);
    assign c3 = g2 | (p2 & c2);
    assign c4 = g3 | (p3 & c3);

    assign sum[0] = p0 ^ 1'b0;
    assign sum[1] = p1 ^ c1;
    assign sum[2] = p2 ^ c2;
    assign sum[3] = p3 ^ c3;
    assign sum[4] = c4;

endmodule