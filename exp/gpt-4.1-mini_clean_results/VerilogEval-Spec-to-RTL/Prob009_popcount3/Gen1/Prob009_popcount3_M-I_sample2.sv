module TopModule(
    input  [2:0] in,
    output [1:0] out
);

    // out[1]: set if two or more bits are set
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[0] & in[2]);

    // out[0]: parity bit - set if odd number of bits are set
    assign out[0] = in[0] ^ in[1] ^ in[2];

endmodule