module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    assign {Co, y} = a + b + Cin;
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1;
    wire [7:0] sum0, sum1;

    // Instantiate two 8-bit adders in ripple carry fashion
    adder_8bit u0 (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum0),
        .Co(c1)
    );

    adder_8bit u1 (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(sum1),
        .Co(Co)
    );

    assign y = {sum1, sum0};
endmodule