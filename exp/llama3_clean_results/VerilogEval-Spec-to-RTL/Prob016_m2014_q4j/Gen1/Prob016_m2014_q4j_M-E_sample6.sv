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

    wire [3:0] s;
    wire [3:0] c;

    HalfAdder ha0(
       .a(x[0]),
       .b(y[0]),
       .sum(s[0]),
       .cout(c[0])
    );

    HalfAdder ha1(
       .a(x[1]),
       .b(y[1]),
       .sum(s[1]),
       .cout(c[1])
    );

    HalfAdder ha2(
       .a(x[2]),
       .b(y[2]),
       .sum(s[2]),
       .cout(c[2])
    );

    HalfAdder ha3(
       .a(x[3]),
       .b(y[3]),
       .sum(s[3]),
       .cout(c[3])
    );

    assign sum[0] = s[0];
    assign sum[1] = s[1] ^ c[0];
    assign sum[2] = s[2] ^ c[1];
    assign sum[3] = s[3] ^ c[2];
    assign sum[4] = c[3];

endmodule