module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0]: Least significant bit of population count (parity)
    // XOR of all input bits gives the parity (odd/even count of '1's)
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1]: Most significant bit of population count (majority)
    // True if at least two of the input bits are '1'
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule