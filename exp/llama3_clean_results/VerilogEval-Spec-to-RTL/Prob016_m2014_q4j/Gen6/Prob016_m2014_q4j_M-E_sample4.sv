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

    wire c1, c2;

    HalfAdder ha0(
       .a(x[0]),
       .b(y[0]),
       .sum(sum[0]),
       .cout(c1)
    );

    FullAdder fa1(
       .a(x[1]),
       .b(y[1]),
       .cin(c1),
       .sum(sum[1]),
       .cout(c2)
    );

    FullAdder fa2(
       .a(x[2]),
       .b(y[2]),
       .cin(c2),
       .sum(sum[2]),
       .cout(sum[4])
    );

    assign sum[3] = x[3] ^ y[3] ^ sum[4];

endmodule