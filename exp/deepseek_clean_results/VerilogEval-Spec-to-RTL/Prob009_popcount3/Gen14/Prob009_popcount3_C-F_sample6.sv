module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = ^in;  // Optimized LSB using XOR (parity)
    assign out[1] = (in[0] + in[1] + in[2]) >> 1;  // MSB from arithmetic sum
endmodule