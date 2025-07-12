module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Calculate each output bit separately
    assign out[0] = in[0] ^ in[1] ^ in[2];  // LSB is XOR of all bits
    assign out[1] = (in[0] & in[1]) | (in[0] & in[2]) | (in[1] & in[2]);  // MSB is majority function

endmodule