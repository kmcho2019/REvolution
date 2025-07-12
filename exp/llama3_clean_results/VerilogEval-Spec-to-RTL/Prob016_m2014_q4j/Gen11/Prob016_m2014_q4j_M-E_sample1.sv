module BitwiseAdder(
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

    wire [3:0] c;

    BitwiseAdder u0(
       .a(x[0]),
       .b(y[0]),
       .cin(1'b0),
       .sum(sum[0]),
       .cout(c[0])
    );

    BitwiseAdder u1(
       .a(x[1]),
       .b(y[1]),
       .cin(c[0]),
       .sum(sum[1]),
       .cout(c[1])
    );

    BitwiseAdder u2(
       .a(x[2]),
       .b(y[2]),
       .cin(c[1]),
       .cout(c[2]),
       .sum(sum[2])
    );

    BitwiseAdder u3(
       .a(x[3]),
       .b(y[3]),
       .cin(c[2]),
       .cout(sum[4]),
       .sum(sum[3])
    );

endmodule