module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0] = parity of in[0], in[1], in[2]
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1] = 1 if at least two bits are '1'
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule