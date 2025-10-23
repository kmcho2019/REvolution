module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Intermediate signals for 2-input gate stages
    wire and_mid1, and_mid2;
    wire or_mid1,  or_mid2;
    wire xor_mid1, xor_mid2;

    // AND gate: ((in[0] & in[1]) & (in[2] & in[3]))
    assign and_mid1 = in[0] & in[1];
    assign and_mid2 = in[2] & in[3];
    assign out_and  = and_mid1 & and_mid2;

    // OR gate: ((in[0] | in[1]) | (in[2] | in[3]))
    assign or_mid1  = in[0] | in[1];
    assign or_mid2  = in[2] | in[3];
    assign out_or   = or_mid1 | or_mid2;

    // XOR gate: ((in[0] ^ in[1]) ^ (in[2] ^ in[3]))
    assign xor_mid1 = in[0] ^ in[1];
    assign xor_mid2 = in[2] ^ in[3];
    assign out_xor  = xor_mid1 ^ xor_mid2;

endmodule