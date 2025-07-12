module FullAdder (
    input  a,
    input  b,
    input  cin,
    output sum,
    output cout
);
    assign sum  = a ^ b ^ cin;
    assign cout = (a & b) | (b & cin) | (a & cin);
endmodule

module TopModule (
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);
    wire carry0, carry1, carry2, carry3;

    FullAdder fa0 (
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry0)
    );

    FullAdder fa1 (
        .a(x[1]),
        .b(y[1]),
        .cin(carry0),
        .sum(sum[1]),
        .cout(carry1)
    );

    FullAdder fa2 (
        .a(x[2]),
        .b(y[2]),
        .cin(carry1),
        .sum(sum[2]),
        .cout(carry2)
    );

    FullAdder fa3 (
        .a(x[3]),
        .b(y[3]),
        .cin(carry2),
        .sum(sum[3]),
        .cout(carry3)
    );

    assign sum[4] = carry3;
endmodule