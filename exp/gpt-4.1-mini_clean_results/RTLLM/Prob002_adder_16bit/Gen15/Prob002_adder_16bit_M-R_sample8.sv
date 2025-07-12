module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire [8:0] sum_with_carry;

    // Perform addition with carry-in in one expression
    assign sum_with_carry = {1'b0, a} + {1'b0, b} + Cin;

    assign y = sum_with_carry[7:0];
    assign Co = sum_with_carry[8];
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Lower 8 bits adder instance
    adder_8bit lower_inst (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    // Upper 8 bits adder instance
    adder_8bit upper_inst (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule