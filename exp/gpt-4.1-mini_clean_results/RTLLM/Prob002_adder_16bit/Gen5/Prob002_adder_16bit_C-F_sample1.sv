module adder_4bit (
    input  [3:0] a,
    input  [3:0] b,
    input        Cin,
    output [3:0] y,
    output       Co
);
    wire [3:0] carry;
    wire [3:0] sum_bits;

    // 4-bit ripple carry adder with explicit carry chain
    assign {carry[0], sum_bits[0]} = a[0] + b[0] + Cin;
    assign {carry[1], sum_bits[1]} = a[1] + b[1] + carry[0];
    assign {carry[2], sum_bits[2]} = a[2] + b[2] + carry[1];
    assign {carry[3], sum_bits[3]} = a[3] + b[3] + carry[2];

    assign y = sum_bits;
    assign Co = carry[3];
endmodule


module adder_8bit (
    input  [7:0] a,
    input  [7:0] b,
    input        Cin,
    output [7:0] y,
    output       Co
);
    wire carry_mid;
    wire [3:0] low_sum, high_sum;

    // Instantiate two 4-bit adders internally for better timing
    adder_4bit low_adder (
        .a(a[3:0]),
        .b(b[3:0]),
        .Cin(Cin),
        .y(low_sum),
        .Co(carry_mid)
    );

    adder_4bit high_adder (
        .a(a[7:4]),
        .b(b[7:4]),
        .Cin(carry_mid),
        .y(high_sum),
        .Co(Co)
    );

    assign y = {high_sum, low_sum};
endmodule


module adder_16bit (
    input  [15:0] a,
    input  [15:0] b,
    input         Cin,
    output [15:0] y,
    output        Co
);
    wire carry_mid;

    // Instantiate two 8-bit adders, chaining carry-out to carry-in
    adder_8bit lower_half (
        .a(a[7:0]),
        .b(b[7:0]),
        .Cin(Cin),
        .y(y[7:0]),
        .Co(carry_mid)
    );

    adder_8bit upper_half (
        .a(a[15:8]),
        .b(b[15:8]),
        .Cin(carry_mid),
        .y(y[15:8]),
        .Co(Co)
    );
endmodule