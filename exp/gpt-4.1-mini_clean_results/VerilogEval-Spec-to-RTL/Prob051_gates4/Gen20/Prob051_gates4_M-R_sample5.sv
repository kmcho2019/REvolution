module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Intermediate signals for balanced trees

    // AND tree: (in[0] & in[1]) & (in[2] & in[3])
    wire and_level1_0 = in[0] & in[1];
    wire and_level1_1 = in[2] & in[3];
    assign out_and = and_level1_0 & and_level1_1;

    // OR tree: (in[0] | in[1]) | (in[2] | in[3])
    wire or_level1_0 = in[0] | in[1];
    wire or_level1_1 = in[2] | in[3];
    assign out_or = or_level1_0 | or_level1_1;

    // XOR tree: (in[0] ^ in[1]) ^ (in[2] ^ in[3])
    wire xor_level1_0 = in[0] ^ in[1];
    wire xor_level1_1 = in[2] ^ in[3];
    assign out_xor = xor_level1_0 ^ xor_level1_1;
endmodule