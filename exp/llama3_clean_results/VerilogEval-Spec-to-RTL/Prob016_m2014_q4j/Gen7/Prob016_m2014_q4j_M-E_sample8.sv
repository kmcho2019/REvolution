module HalfAdder(
    input   a,
    input   b,
    output  sum,
    output  cout
);

    assign sum = a ^ b;
    assign cout = a & b;

endmodule

module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);

    wire [1:0] c1;
    wire [1:0] c2;

    HalfAdder ha0(x[0], y[0], sum[0], c1[0]);
    HalfAdder ha1(x[1], y[1], sum[1], c1[1]);

    HalfAdder ha2(x[2], y[2], sum[2], c2[0]);
    HalfAdder ha3(x[3], y[3], sum[3], c2[1]);

    HalfAdder ha4(c1[0], c1[1], sum[4], sum[4]);
    HalfAdder ha5(c2[0], c2[1], , sum[4]);

endmodule