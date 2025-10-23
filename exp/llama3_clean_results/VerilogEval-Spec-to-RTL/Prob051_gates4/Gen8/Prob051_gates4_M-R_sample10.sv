module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Compute 4-input AND
    assign out_and = in[3] & in[2] & in[1] & in[0];

    // Compute 4-input OR
    assign out_or = in[3] | in[2] | in[1] | in[0];

    // Compute 4-input XOR
    assign out_xor = in[3] ^ in[2] ^ in[1] ^ in[0];

endmodule