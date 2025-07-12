module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate wires for AND tree
    wire and_stage1, and_stage2;
    // Intermediate wires for OR tree
    wire or_stage1, or_stage2;
    // Intermediate wires for XOR tree
    wire xor_stage1, xor_stage2;

    // AND tree implementation
    assign and_stage1 = in[0] & in[1];
    assign and_stage2 = in[2] & in[3];
    assign out_and = and_stage1 & and_stage2;

    // OR tree implementation
    assign or_stage1 = in[0] | in[1];
    assign or_stage2 = in[2] | in[3];
    assign out_or = or_stage1 | or_stage2;

    // XOR tree implementation
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = in[2] ^ in[3];
    assign out_xor = xor_stage1 ^ xor_stage2;

endmodule