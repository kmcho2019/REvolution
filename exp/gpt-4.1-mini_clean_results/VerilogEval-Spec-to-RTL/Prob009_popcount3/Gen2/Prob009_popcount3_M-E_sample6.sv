module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[1] is set if at least two of the input bits are high (majority function)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // out[0] is set if the number of input bits high is odd (parity)
    assign out[0] = in[0] ^ in[1] ^ in[2];

endmodule