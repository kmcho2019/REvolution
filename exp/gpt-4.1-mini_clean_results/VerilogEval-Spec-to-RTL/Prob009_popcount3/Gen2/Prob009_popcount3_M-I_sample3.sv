module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // Population count using explicit boolean logic:
    // out[0] = parity (XOR of all bits)
    // out[1] = majority function (at least two bits set)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule