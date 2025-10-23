module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0] = parity of input bits (1 if odd number of 1s)
    assign out[0] = in[0] ^ in[1] ^ in[2];
    // out[1] = 1 if population count >= 2 (any two or more bits are 1)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

endmodule