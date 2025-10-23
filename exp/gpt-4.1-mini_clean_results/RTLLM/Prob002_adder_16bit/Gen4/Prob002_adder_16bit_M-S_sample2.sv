module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] sum,
    output       Co
);
    // Use built-in addition for simplicity; synthesis will infer carry logic.
    assign {Co, sum} = a + b + Cin;
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c1;

    adder_8bit adder_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .sum(y[7:0]),
        .Co(c1)
    );

    adder_8bit adder_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .sum(y[15:8]),
        .Co(Co)
    );
endmodule