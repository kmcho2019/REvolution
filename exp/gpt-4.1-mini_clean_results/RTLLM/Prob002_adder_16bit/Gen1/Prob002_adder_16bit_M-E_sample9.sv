module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] sum,
    output       Co
);
    assign {Co, sum} = a + b + Cin;
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1, c2, c3;

    adder_4bit adder0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .sum(y[3:0]),
        .Co(c1)
    );

    adder_4bit adder1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c1),
        .sum(y[7:4]),
        .Co(c2)
    );

    adder_4bit adder2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c2),
        .sum(y[11:8]),
        .Co(c3)
    );

    adder_4bit adder3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c3),
        .sum(y[15:12]),
        .Co(Co)
    );
endmodule