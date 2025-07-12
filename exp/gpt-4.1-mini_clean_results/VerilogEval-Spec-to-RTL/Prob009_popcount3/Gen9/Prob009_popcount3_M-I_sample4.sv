module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0]: parity (LSB of popcount) - XOR of all input bits
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1]: majority (MSB of popcount) - true if at least two inputs are high
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule