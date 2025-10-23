module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire and_stage1_0, and_stage1_1;
    wire or_stage1_0,  or_stage1_1;
    wire xor_stage1_0, xor_stage1_1;

    // 2-input AND gates
    and u_and0(and_stage1_0, in[0], in[1]);
    and u_and1(and_stage1_1, in[2], in[3]);
    and u_and2(out_and, and_stage1_0, and_stage1_1);

    // 2-input OR gates
    or u_or0(or_stage1_0, in[0], in[1]);
    or u_or1(or_stage1_1, in[2], in[3]);
    or u_or2(out_or, or_stage1_0, or_stage1_1);

    // 2-input XOR gates
    xor u_xor0(xor_stage1_0, in[0], in[1]);
    xor u_xor1(xor_stage1_1, in[2], in[3]);
    xor u_xor2(out_xor, xor_stage1_0, xor_stage1_1);

endmodule