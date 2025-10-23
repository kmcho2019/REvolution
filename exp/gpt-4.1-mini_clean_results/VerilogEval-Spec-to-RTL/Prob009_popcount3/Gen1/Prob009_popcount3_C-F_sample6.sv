module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // LSB: parity of all three bits (odd number of ones)
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // MSB: set if at least two bits are '1'
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule