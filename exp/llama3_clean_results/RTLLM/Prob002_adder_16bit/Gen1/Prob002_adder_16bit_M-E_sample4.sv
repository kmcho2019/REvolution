// 1-bit full adder module
module adder_1bit(
    input  a,
    input  b,
    input  Cin,
    output y,
    output Co
);
    assign y = a ^ b ^ Cin;
    assign Co = (a & b) | (a & Cin) | (b & Cin);
endmodule

// 4-bit full adder module
module adder_4bit(
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire        c1, c2, c3;
    wire  [3:0] y_int;

    adder_1bit u1(
        .a(a[0]),
        .b(b[0]),
        .Cin(Cin),
        .y(y_int[0]),
        .Co(c1)
    );

    adder_1bit u2(
        .a(a[1]),
        .b(b[1]),
        .Cin(c1),
        .y(y_int[1]),
        .Co(c2)
    );

    adder_1bit u3(
        .a(a[2]),
        .b(b[2]),
        .Cin(c2),
        .y(y_int[2]),
        .Co(c3)
    );

    adder_1bit u4(
        .a(a[3]),
        .b(b[3]),
        .Cin(c3),
        .y(y_int[3]),
        .Co(Co)
    );

    assign y = y_int;
endmodule

// 8-bit full adder module
module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire        c4;
    wire  [3:0] y1, y2;

    adder_4bit u1(
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y1),
        .Co(c4)
    );

    adder_4bit u2(
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c4),
        .y(y2),
        .Co(Co)
    );

    assign y = {y2, y1};
endmodule

// 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire        c8;
    wire  [7:0] y1, y2;

    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y1),
        .Co(c8)
    );

    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y2),
        .Co(Co)
    );

    assign y = {y2, y1};
endmodule