// Define the 8-bit adder module
module adder_8bit(
    input [7:0] a,
    input [7:0] b,
    input Cin,
    output [7:0] y,
    output Co
);

    wire [7:0] sum;
    assign sum = a + b + Cin;
    assign y = sum;
    assign Co = (a[7] & b[7]) | (a[7] & Cin) | (b[7] & Cin) | ((sum[7:0] >= 8'd256) ? 1'b1 : 1'b0);

endmodule

// Define the 16-bit adder module using two 8-bit adders
module adder_16bit(
    input [15:0] a,
    input [15:0] b,
    input Cin,
    output [15:0] y,
    output Co
);

    wire Cout_lower;
    adder_8bit adder_lower(
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(Cout_lower)
    );

    adder_8bit adder_upper(
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(Cout_lower),
        .y(y[15:8]),
        .Co(Co)
    );

endmodule