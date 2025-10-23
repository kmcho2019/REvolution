module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // AND gate implementation
    wire and_stage1 = in[0] & in[1];
    wire and_stage2 = in[2] & in[3];
    assign out_and = and_stage1 & and_stage2;

    // OR gate implementation
    wire or_stage1 = in[0] | in[1];
    wire or_stage2 = in[2] | in[3];
    assign out_or = or_stage1 | or_stage2;

    // XOR gate implementation
    wire xor_stage1 = in[0] ^ in[1];
    wire xor_stage2 = in[2] ^ in[3];
    assign out_xor = xor_stage1 ^ xor_stage2;

endmodule