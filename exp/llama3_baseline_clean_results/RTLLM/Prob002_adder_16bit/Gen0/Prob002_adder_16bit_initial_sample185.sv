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
    assign Co = (sum > 8'd255) ? 1'b1 : 1'b0;

endmodule

module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire [7:0] sum1;
    wire Co1;
    wire [7:0] sum2;
    wire Co2;

    adder_8bit u1(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum1),
        .Co(Co1)
    );

    adder_8bit u2(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Co1),
        .y(sum2),
        .Co(Co2)
    );

    assign y = {sum2, sum1};
    assign Co = Co2;

endmodule