module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // AND and OR outputs using reduction operators for compactness and efficiency
    assign out_and = &in;
    assign out_or  = |in;

    // XOR output built from cascaded 2-input XOR gates for potentially improved delay and power
    wire xor_0_1, xor_2_3;

    assign xor_0_1 = in[0] ^ in[1];
    assign xor_2_3 = in[2] ^ in[3];
    assign out_xor = xor_0_1 ^ xor_2_3;

endmodule