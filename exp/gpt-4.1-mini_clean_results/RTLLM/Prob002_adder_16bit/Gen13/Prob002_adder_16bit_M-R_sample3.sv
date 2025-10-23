module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [8:0] sum_ext;
    assign sum_ext = a + b + Cin;
    assign y = sum_ext[7:0];
    assign Co = sum_ext[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire c_mid;
    wire [7:0] sum_low, sum_high;

    // Instantiate two 8-bit adders
    adder_8bit u_low (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(sum_low),
        .Co(c_mid)
    );

    adder_8bit u_high (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(c_mid),
        .y(sum_high),
        .Co(Co)
    );

    assign y = {sum_high, sum_low};
endmodule