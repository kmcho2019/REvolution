module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Co
);
    assign {Co, sum} = a + b + Cin;
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Co
);
    wire c4;

    adder_4bit lower_4bit (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(sum[3:0]),
        .Co(c4)
    );

    adder_4bit upper_4bit (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c4),
        .sum(sum[7:4]),
        .Co(Co)
    );
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    adder_8bit lower_8bit (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_8bit (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .sum(y[15:8]),
        .Co(Co)
    );
endmodule