module TopModule(input [3:0] in, output out_and, out_or, out_xor);
    // AND tree implementation
    wire and_stage1_0, and_stage1_1;
    assign and_stage1_0 = in[0] & in[1];
    assign and_stage1_1 = in[2] & in[3];
    assign out_and = and_stage1_0 & and_stage1_1;

    // OR tree implementation
    wire or_stage1_0, or_stage1_1;
    assign or_stage1_0 = in[0] | in[1];
    assign or_stage1_1 = in[2] | in[3];
    assign out_or = or_stage1_0 | or_stage1_1;

    // XOR tree implementation
    wire xor_stage1_0, xor_stage1_1;
    assign xor_stage1_0 = in[0] ^ in[1];
    assign xor_stage1_1 = in[2] ^ in[3];
    assign out_xor = xor_stage1_0 ^ xor_stage1_1;
endmodule