module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    wire sum0, carry0;
    wire sum1, carry1;

    // Half adder for in[0] + in[1]
    assign sum0   = in[0] ^ in[1];
    assign carry0 = in[0] & in[1];

    // Half adder for sum0 + in[2]
    assign sum1   = sum0 ^ in[2];
    assign carry1 = sum0 & in[2];

    // Final 2-bit count: LSB = sum1, MSB = carry0 + carry1 (logical OR since carry bits are 1-bit)
    assign out[0] = sum1;
    assign out[1] = carry0 | carry1;
endmodule