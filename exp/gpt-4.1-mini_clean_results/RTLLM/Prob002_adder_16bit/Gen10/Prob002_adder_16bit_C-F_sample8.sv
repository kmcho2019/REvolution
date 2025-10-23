module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire c1, c2, c3;

    assign {c1, y[0]} = a[0] + b[0] + Cin;
    assign {c2, y[1]} = a[1] + b[1] + c1;
    assign {c3, y[2]} = a[2] + b[2] + c2;
    assign {Co, y[3]} = a[3] + b[3] + c3;
endmodule


module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire carry_mid;

    // Instantiate two 4-bit adders chained together
    adder_4bit adder_low (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(y[3:0]),
        .Co(carry_mid)
    );

    adder_4bit adder_high (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_mid),
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
    wire carry_mid;

    adder_8bit lower_8bit (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_8bit (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule