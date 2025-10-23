module TopModule(
    input  [3:0] x,
    input  [3:0] y,
    output [4:0] sum
);

    // Internal carry signals
    wire c1, c2, c3;

    // Full adder for bit 0
    full_adder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .s(sum[0]),
        .cout(c1)
    );

    // Full adder for bit 1
    full_adder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(c1),
        .s(sum[1]),
        .cout(c2)
    );

    // Full adder for bit 2
    full_adder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(c2),
        .s(sum[2]),
        .cout(c3)
    );

    // Full adder for bit 3
    full_adder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(c3),
        .s(sum[3]),
        .cout(sum[4])
    );

endmodule

// Full adder module
module full_adder(
    input  a,
    input  b,
    input  cin,
    output s,
    output cout
);

    assign s = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule