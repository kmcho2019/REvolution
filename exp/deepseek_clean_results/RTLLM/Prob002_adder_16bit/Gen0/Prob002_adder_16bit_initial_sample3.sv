module adder_1bit (
    input a,
    input b,
    input cin,
    output sum,
    output cout
);
    assign sum = a ^ b ^ cin;
    assign cout = (a & b) | (a & cin) | (b & cin);
endmodule

module adder_8bit (
    input [7:0] a,
    input [7:0] b,
    input cin,
    output [7:0] sum,
    output cout
);
    wire [7:0] carry;

    adder_1bit fa0 (a[0], b[0], cin,    sum[0], carry[0]);
    adder_1bit fa1 (a[1], b[1], carry[0], sum[1], carry[1]);
    adder_1bit fa2 (a[2], b[2], carry[1], sum[2], carry[2]);
    adder_1bit fa3 (a[3], b[3], carry[2], sum[3], carry[3]);
    adder_1bit fa4 (a[4], b[4], carry[3], sum[4], carry[4]);
    adder_1bit fa5 (a[5], b[5], carry[4], sum[5], carry[5]);
    adder_1bit fa6 (a[6], b[6], carry[5], sum[6], carry[6]);
    adder_1bit fa7 (a[7], b[7], carry[6], sum[7], cout);
endmodule

module adder_16bit (
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);
    wire carry_middle;

    adder_8bit lower_adder (
        .a(a[7:0]),
        .b(b[7:0]),
        .cin(Cin),
        .sum(y[7:0]),
        .cout(carry_middle)
    );

    adder_8bit upper_adder (
        .a(a[15:8]),
        .b(b[15:8]),
        .cin(carry_middle),
        .sum(y[15:8]),
        .cout(Co)
    );
endmodule