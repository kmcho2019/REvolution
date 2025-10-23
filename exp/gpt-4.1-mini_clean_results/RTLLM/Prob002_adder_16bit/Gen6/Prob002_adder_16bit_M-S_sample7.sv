module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry;
    wire [7:0] sum_bits;

    assign {carry[0], sum_bits[0]} = a[0] + b[0] + Cin;
    assign {carry[1], sum_bits[1]} = a[1] + b[1] + carry[0];
    assign {carry[2], sum_bits[2]} = a[2] + b[2] + carry[1];
    assign {carry[3], sum_bits[3]} = a[3] + b[3] + carry[2];
    assign {carry[4], sum_bits[4]} = a[4] + b[4] + carry[3];
    assign {carry[5], sum_bits[5]} = a[5] + b[5] + carry[4];
    assign {carry[6], sum_bits[6]} = a[6] + b[6] + carry[5];
    assign {carry[7], sum_bits[7]} = a[7] + b[7] + carry[6];

    assign y = sum_bits;
    assign Co = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1;
    wire [7:0] sum_low, sum_high;

    adder_8bit u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c1)
    );

    adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule