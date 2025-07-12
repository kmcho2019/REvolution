module TopModule (
    input [2:0] in,
    output [1:0] out
);
    assign out[0] = in[0] ^ in[1] ^ in[2];  // LSB: odd parity (sum mod 2)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]);  // MSB: optimized majority function
endmodule