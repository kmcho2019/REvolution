module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Use reduction operators for AND and OR - most concise and optimal
    assign out_and = &in;
    assign out_or  = |in;

    // Use balanced tree structure for XOR - better timing characteristics
    wire xor_stage1, xor_stage2;
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = in[2] ^ in[3];
    assign out_xor = xor_stage1 ^ xor_stage2;

endmodule