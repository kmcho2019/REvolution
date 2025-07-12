module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire c1, c2, c3;

    // Full adders chained
    assign {c1, y[0]} = a[0] + b[0] + Cin;
    assign {c2, y[1]} = a[1] + b[1] + c1;
    assign {c3, y[2]} = a[2] + b[2] + c2;
    assign {Co, y[3]} = a[3] + b[3] + c3;
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c4, c8, c12;

    adder_4bit block0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c4)
    );

    adder_4bit block1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c4),
        .y(y[7:4]),
        .Co(c8)
    );

    adder_4bit block2 (
        .a(a[11:8]),
        .b(b[11:8]),
        .Cin(c8),
        .y(y[11:8]),
        .Co(c12)
    );

    adder_4bit block3 (
        .a(a[15:12]),
        .b(b[15:12]),
        .Cin(c12),
        .y(y[15:12]),
        .Co(Co)
    );
endmodule