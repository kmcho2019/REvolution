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

    HalfAdder ha1(
        .a(x[0]),
        .b(y[0]),
        .sum(sum[0]),
        .cout(c1[0])
    );

    HalfAdder ha2(
        .a(x[1]),
        .b(y[1]),
        .sum(sum[1]),
        .cout(c1[1])
    );

    assign c2[0] = c1[0] | c1[1];

    HalfAdder ha3(
        .a(x[2]),
        .b(y[2]),
        .sum(sum[2]),
        .cout(c2[1])
    );

    assign sum[3] = x[3] ^ y[3] ^ (c1[0] | c1[1] | c2[1]);
    assign sum[4] = (x[3] & y[3]) | (x[3] & (c1[0] | c1[1] | c2[1])) | (y[3] & (c1[0] | c1[1] | c2[1]));

endmodule