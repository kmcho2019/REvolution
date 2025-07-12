module HalfAdder(
    input   a,
    input   b,
    output  sum,
    output  cout
);

    assign sum = a ^ b;
    assign cout = a & b;

endmodule

module FullAdder(
    input   a,
    input   b,
    input   cin,
    output  sum,
    output  cout
);

    wire p, g;
    assign p = a ^ b;
    assign g = (a & b);
    assign sum = p ^ cin;
    assign cout = g | (p & cin);

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire c1, c2, c3;
    wire g0, g1, g2, g3;
    wire p0, p1, p2, p3;

    assign g0 = x[0] & y[0];
    assign p0 = x[0] ^ y[0];
    assign c1 = g0;

    assign g1 = x[1] & y[1];
    assign p1 = x[1] ^ y[1];
    assign c2 = g1 | (p1 & c1);

    assign g2 = x[2] & y[2];
    assign p2 = x[2] ^ y[2];
    assign c3 = g2 | (p2 & c2);

    assign sum[0] = p0;
    assign sum[1] = p1 ^ c1;
    assign sum[2] = p2 ^ c2;
    assign sum[3] = x[3] ^ y[3] ^ c3;
    assign sum[4] = x[3] & y[3] | (x[3] & c3) | (y[3] & c3);

endmodule