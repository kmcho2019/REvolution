// 8-bit full adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] sum;
    assign sum = a + b + Cin;
    assign y = sum[7:0];
    assign Co = (a[7] & b[7]) | (a[7] & sum[7]) | (b[7] & sum[7]);

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire C1;

    // Instantiate the first 8-bit adder for the lower 8 bits
    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(C1)
    );

    // Instantiate the second 8-bit adder for the upper 8 bits
    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(C1),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule