module TopModule (
    input  [7:0] in,
    output      parity
);
    wire xor_stage1_0, xor_stage1_1, xor_stage1_2, xor_stage1_3;
    wire xor_stage2_0, xor_stage2_1;

    // Stage 1: XOR pairs of input bits
    assign xor_stage1_0 = in[0] ^ in[1];
    assign xor_stage1_1 = in[2] ^ in[3];
    assign xor_stage1_2 = in[4] ^ in[5];
    assign xor_stage1_3 = in[6] ^ in[7];

    // Stage 2: XOR pairs of previous stage results
    assign xor_stage2_0 = xor_stage1_0 ^ xor_stage1_1;
    assign xor_stage2_1 = xor_stage1_2 ^ xor_stage1_3;

    // Final parity is XOR of last two signals
    assign parity = xor_stage2_0 ^ xor_stage2_1;
endmodule