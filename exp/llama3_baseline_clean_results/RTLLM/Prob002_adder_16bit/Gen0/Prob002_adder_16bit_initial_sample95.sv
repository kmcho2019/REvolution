module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);

    assign {Co, y} = a + b + Cin;

endmodule

module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);

    wire        mid_Co;
    assign      mid_Co = Cin + a[7] + b[7] + (a[6:0] + b[6:0]);

    adder_8bit u_adder_0(
        .a    (a[7:0]),
        .b    (b[7:0]),
        .Cin  (Cin),
        .y    (y[7:0]),
        .Co   (mid_Co)
    );

    adder_8bit u_adder_1(
        .a    (a[15:8]),
        .b    (b[15:8]),
        .Cin  (mid_Co),
        .y    (y[15:8]),
        .Co   (Co)
    );

endmodule