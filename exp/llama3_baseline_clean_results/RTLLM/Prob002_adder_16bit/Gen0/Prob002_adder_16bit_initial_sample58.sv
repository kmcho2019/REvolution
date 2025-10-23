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
    assign Co = (sum[7] == 1) ? 1 : 0;

endmodule

// 16-bit full adder module
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum_lo;
    wire [7:0] sum_hi;
    wire Co_lo;

    adder_8bit u_lo(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_lo),
        .Co(Co_lo)
    );

    adder_8bit u_hi(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co_lo),
        .y(sum_hi),
        .Co(Co)
    );

    assign y[7:0] = sum_lo;
    assign y[15:8] = sum_hi;

endmodule