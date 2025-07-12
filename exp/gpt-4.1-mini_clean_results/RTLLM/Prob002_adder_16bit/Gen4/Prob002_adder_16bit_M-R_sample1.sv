module full_adder (
    input  a,
    input  b,
    input  Cin,
    output sum,
    output Cout
);
    assign sum  = a ^ b ^ Cin;
    assign Cout = (a & b) | (a & Cin) | (b & Cin);
endmodule

module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire c1, c2, c3;

    full_adder fa0 (.a(a[0]), .b(b[0]), .Cin(Cin),  .sum(y[0]), .Cout(c1));
    full_adder fa1 (.a(a[1]), .b(b[1]), .Cin(c1),   .sum(y[1]), .Cout(c2));
    full_adder fa2 (.a(a[2]), .b(b[2]), .Cin(c2),   .sum(y[2]), .Cout(c3));
    full_adder fa3 (.a(a[3]), .b(b[3]), .Cin(c3),   .sum(y[3]), .Cout(Co));
endmodule

module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire c4;

    adder_4bit u0 (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(c4)
    );

    adder_4bit u1 (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(c4),
        .y(y[7:4]),
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
    wire c8;

    adder_8bit u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(c8)
    );

    adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule