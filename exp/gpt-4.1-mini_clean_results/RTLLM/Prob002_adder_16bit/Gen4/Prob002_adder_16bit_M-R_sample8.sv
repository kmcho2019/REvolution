module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Cout
);
    wire [8:0] result;

    assign result = a + b + Cin;
    assign sum  = result[7:0];
    assign Cout = result[8];
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
        .sum(y[7:0]),
        .Cout(c8)
    );

    adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c8),
        .sum(y[15:8]),
        .Cout(Co)
    );
endmodule