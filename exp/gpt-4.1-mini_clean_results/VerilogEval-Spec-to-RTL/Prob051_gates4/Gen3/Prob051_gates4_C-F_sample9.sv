module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Use reduction operators for AND and OR for optimal compactness and clarity
    assign out_and = &in;
    assign out_or  = |in;

    // Explicit 2-input XOR gate instantiation chain for out_xor
    wire xor_stage1_0, xor_stage1_1;
    xor u_xor0(xor_stage1_0, in[0], in[1]);
    xor u_xor1(xor_stage1_1, in[2], in[3]);
    xor u_xor2(out_xor, xor_stage1_0, xor_stage1_1);

endmodule