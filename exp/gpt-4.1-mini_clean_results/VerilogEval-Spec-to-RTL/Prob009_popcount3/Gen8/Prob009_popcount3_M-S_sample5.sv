module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    assign out[0] = in[0] ^ in[1] ^ in[2];                          // LSB: parity of input bits
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]); // MSB: at least two bits set
endmodule