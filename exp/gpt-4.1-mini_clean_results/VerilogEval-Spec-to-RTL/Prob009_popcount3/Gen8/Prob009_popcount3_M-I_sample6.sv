module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // LSB: XOR of all bits (parity)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // MSB: majority function of the three inputs
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule