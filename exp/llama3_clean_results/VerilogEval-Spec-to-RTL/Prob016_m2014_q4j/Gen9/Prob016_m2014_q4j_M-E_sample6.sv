// HalfAdder module
module HalfAdder(
    input   a,
    input   b,
    output  sum,
    output  cout
);
    assign sum = a ^ b;
    assign cout = a & b;
endmodule

// TopModule using half-adders and multiplexers
module TopModule(
    input   [3:0] x,
    input   [3:0] y,
    output  [4:0] sum
);
    wire [3:0] sum_bits;
    wire [3:0] carry_bits;

    HalfAdder ha_0(x[0], y[0], sum_bits[0], carry_bits[0]);
    HalfAdder ha_1(x[1], y[1], sum_bits[1], carry_bits[1]);
    HalfAdder ha_2(x[2], y[2], sum_bits[2], carry_bits[2]);
    HalfAdder ha_3(x[3], y[3], sum_bits[3], carry_bits[3]);

    assign sum[0] = sum_bits[0];
    assign sum[1] = sum_bits[1] ^ carry_bits[0];
    assign sum[2] = sum_bits[2] ^ carry_bits[1];
    assign sum[3] = sum_bits[3] ^ carry_bits[2];
    assign sum[4] = carry_bits[3];

endmodule