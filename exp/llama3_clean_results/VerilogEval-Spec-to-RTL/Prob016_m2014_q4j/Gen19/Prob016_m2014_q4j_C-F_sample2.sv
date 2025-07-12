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

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [3:0] carry;
    wire [3:0] s;

    FullAdder fa0(x[0], y[0], 1'b0, s[0], carry[0]);
    FullAdder fa1(x[1], y[1], carry[0], s[1], carry[1]);
    FullAdder fa2(x[2], y[2], carry[1], s[2], carry[2]);
    FullAdder fa3(x[3], y[3], carry[2], s[3], carry[3]);

    assign sum[0] = s[0];
    assign sum[1] = s[1];
    assign sum[2] = s[2];
    assign sum[3] = s[3];
    assign sum[4] = carry[3];

endmodule