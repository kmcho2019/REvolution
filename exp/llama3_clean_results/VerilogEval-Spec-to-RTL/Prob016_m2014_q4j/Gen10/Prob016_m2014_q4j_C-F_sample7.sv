// Improved FullAdder module with explicit output port definitions
module FullAdder(
    input   logic a,
    input   logic b,
    input   logic cin,
    output  logic sum,
    output  logic cout
);

    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);

endmodule

// Improved TopModule with better naming conventions and explicit port widths
module TopModule(
    input   logic [3:0] x,
    input   logic [3:0] y,
    output  logic [4:0] sum
);

    wire logic [2:0] carry; // Declare carry wires with logic type

    FullAdder fa0(
        .a(x[0]),
        .b(y[0]),
        .cin(1'b0),
        .sum(sum[0]),
        .cout(carry[0])
    );

    FullAdder fa1(
        .a(x[1]),
        .b(y[1]),
        .cin(carry[0]),
        .sum(sum[1]),
        .cout(carry[1])
    );

    FullAdder fa2(
        .a(x[2]),
        .b(y[2]),
        .cin(carry[1]),
        .sum(sum[2]),
        .cout(carry[2])
    );

    FullAdder fa3(
        .a(x[3]),
        .b(y[3]),
        .cin(carry[2]),
        .sum(sum[3]),
        .cout(sum[4])
    );

endmodule