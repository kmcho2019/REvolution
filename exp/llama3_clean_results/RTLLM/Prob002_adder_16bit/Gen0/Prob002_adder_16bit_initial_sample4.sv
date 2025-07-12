// 8-bit full adder module
module adder_8bit(
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [8:0] sum;

    assign sum = {1'b0, a} + {1'b0, b} + Cin;
    assign y = sum[7:0];
    assign Co = sum[8];
endmodule

// 16-bit full adder module
module adder_16bit(
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire        c1;
    wire  [7:0] y1, y2;

    // Instantiate two 8-bit adders
    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y1),
        .Co(c1)
    );

    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c1),
        .y(y2),
        .Co(Co)
    );

    // Combine the outputs of the two 8-bit adders
    assign y = {y2, y1};
endmodule