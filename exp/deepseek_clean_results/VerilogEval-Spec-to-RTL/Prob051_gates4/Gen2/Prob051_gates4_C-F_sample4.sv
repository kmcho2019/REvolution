module TopModule(
    input [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Use reduction operators for AND and OR
    assign out_and = &in;
    assign out_or  = |in;

    // Use tree structure for XOR
    wire xor_stage1, xor_stage2;
    assign xor_stage1 = in[0] ^ in[1];
    assign xor_stage2 = in[2] ^ in[3];
    assign out_xor = xor_stage1 ^ xor_stage2;

endmodule