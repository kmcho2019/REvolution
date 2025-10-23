module TopModule (
    input [2:0] in,
    output [1:0] out
);

    // Bit 0 of output is XOR of all input bits (sum modulo 2)
    // Bit 1 of output is majority function (carry out)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule