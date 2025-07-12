module TopModule (
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // 4-input AND as tree of 2-input ANDs
    wire and_stage1_0, and_stage1_1;
    assign and_stage1_0 = in[0] & in[1];
    assign and_stage1_1 = in[2] & in[3];
    assign out_and = and_stage1_0 & and_stage1_1;

    // 4-input OR as tree of 2-input ORs
    wire or_stage1_0, or_stage1_1;
    assign or_stage1_0 = in[0] | in[1];
    assign or_stage1_1 = in[2] | in[3];
    assign out_or = or_stage1_0 | or_stage1_1;

    // 4-input XOR as linear cascade (since XOR isn't associative)
    wire xor_stage1, xor_stage2;
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = xor_stage1 ^ in[2];
    assign out_xor = xor_stage2 ^ in[3];

endmodule