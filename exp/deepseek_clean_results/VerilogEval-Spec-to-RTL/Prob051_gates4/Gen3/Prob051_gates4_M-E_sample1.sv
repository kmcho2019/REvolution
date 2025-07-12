module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND gate implementation (balanced binary tree)
    wire and_stage1_0, and_stage1_1;
    assign and_stage1_0 = in[0] & in[1];
    assign and_stage1_1 = in[2] & in[3];
    assign out_and = and_stage1_0 & and_stage1_1;

    // OR gate implementation (balanced binary tree)
    wire or_stage1_0, or_stage1_1;
    assign or_stage1_0 = in[0] | in[1];
    assign or_stage1_1 = in[2] | in[3];
    assign out_or = or_stage1_0 | or_stage1_1;

    // XOR gate implementation (parity calculation)
    wire xor_stage1_0, xor_stage1_1;
    assign xor_stage1_0 = in[0] ^ in[1];
    assign xor_stage1_1 = in[2] ^ in[3];
    assign out_xor = xor_stage1_0 ^ xor_stage1_1;

endmodule