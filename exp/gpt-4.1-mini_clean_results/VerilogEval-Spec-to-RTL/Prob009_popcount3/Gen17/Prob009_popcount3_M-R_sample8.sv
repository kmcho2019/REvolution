module TopModule (
    input  [2:0] in,
    output [1:0] out
);
    // LSB of output (out[0]) is parity of inputs: XOR of all bits
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // MSB of output (out[1]) is 1 if at least two bits are set
    // Calculate using pairwise ANDs ORed together
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);
endmodule