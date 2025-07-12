module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] carry;
    wire [3:0] sum_bits;

    // Full adders for each bit with ripple carry inside 4-bit block
    assign {carry[0], sum_bits[0]} = a[0] + b[0] + Cin;
    assign {carry[1], sum_bits[1]} = a[1] + b[1] + carry[0];
    assign {carry[2], sum_bits[2]} = a[2] + b[2] + carry[1];
    assign {carry[3], sum_bits[3]} = a[3] + b[3] + carry[2];

    assign y = sum_bits;
    assign Co = carry[3];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;
    wire [3:0] sum0, sum1, sum2, sum3;

    // Instantiate four 4-bit adders
    adder_4bit u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(c1)
    );

    adder_4bit u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .y(sum1),
        .Co(c2)
    );

    adder_4bit u2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .y(sum2),
        .Co(c3)
    );

    adder_4bit u3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .y(sum3),
        .Co(Co)
    );

    // Concatenate results
    assign y = {sum3, sum2, sum1, sum0};
endmodule