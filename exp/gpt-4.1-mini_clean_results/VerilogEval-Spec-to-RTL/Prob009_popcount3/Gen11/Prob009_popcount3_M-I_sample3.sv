module TopModule (
    input  [2:0] in,
    output [1:0] out
);

    // out[0]: parity of the three bits
    assign out[0] = in[0] ^ in[1] ^ in[2];

    // out[1]: set if at least two inputs are high (majority)
    assign out[1] = (in[0] & in[1]) | (in[1] & in[2]) | (in[2] & in[0]);

endmodule