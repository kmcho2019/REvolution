module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // AND implementation using 2-input AND gates
    wire and_stage1, and_stage2;
    assign and_stage1 = in[0] & in[1];
    assign and_stage2 = and_stage1 & in[2];
    assign out_and = and_stage2 & in[3];

    // OR implementation using 2-input OR gates
    wire or_stage1, or_stage2;
    assign or_stage1 = in[0] | in[1];
    assign or_stage2 = or_stage1 | in[2];
    assign out_or = or_stage2 | in[3];

    // XOR implementation using 2-input XOR gates
    wire xor_stage1, xor_stage2;
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = xor_stage1 ^ in[2];
    assign out_xor = xor_stage2 ^ in[3];

endmodule