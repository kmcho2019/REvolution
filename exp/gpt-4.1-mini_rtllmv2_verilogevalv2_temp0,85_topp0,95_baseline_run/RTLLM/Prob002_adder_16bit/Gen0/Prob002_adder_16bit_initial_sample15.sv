module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [7:0] carry;

    assign {carry[0], y[0]} = a[0] + b[0] + Cin;
    assign {carry[1], y[1]} = a[1] + b[1] + carry[0];
    assign {carry[2], y[2]} = a[2] + b[2] + carry[1];
    assign {carry[3], y[3]} = a[3] + b[3] + carry[2];
    assign {carry[4], y[4]} = a[4] + b[4] + carry[3];
    assign {carry[5], y[5]} = a[5] + b[5] + carry[4];
    assign {carry[6], y[6]} = a[6] + b[6] + carry[5];
    assign {carry[7], y[7]} = a[7] + b[7] + carry[6];

    assign Co = carry[7];
endmodule

module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);

    wire carry_mid;

    // Lower 8 bits adder
    adder_8bit lower_adder (
        .a    (a[7:0]),
        .b    (b[7:0]),
        .Cin  (Cin),
        .y    (y[7:0]),
        .Co   (carry_mid)
    );

    // Upper 8 bits adder
    adder_8bit upper_adder (
        .a    (a[15:8]),
        .b    (b[15:8]),
        .Cin  (carry_mid),
        .y    (y[15:8]),
        .Co   (Co)
    );

endmodule