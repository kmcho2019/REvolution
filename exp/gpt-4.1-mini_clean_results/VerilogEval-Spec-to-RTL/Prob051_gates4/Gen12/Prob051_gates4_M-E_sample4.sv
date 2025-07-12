module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Intermediate wires for cascade stages
    wire and_stage1, and_stage2;
    wire or_stage1, or_stage2;
    wire xor_stage1, xor_stage2;

    // 4-input AND implemented by cascading 2-input AND gates
    and and1(and_stage1, in[0], in[1]);
    and and2(and_stage2, and_stage1, in[2]);
    and and3(out_and,   and_stage2, in[3]);

    // 4-input OR implemented by cascading 2-input OR gates
    or  or1(or_stage1,  in[0], in[1]);
    or  or2(or_stage2,  or_stage1, in[2]);
    or  or3(out_or,     or_stage2, in[3]);

    // 4-input XOR implemented by cascading 2-input XOR gates
    xor xor1(xor_stage1, in[0], in[1]);
    xor xor2(xor_stage2, xor_stage1, in[2]);
    xor xor3(out_xor,    xor_stage2, in[3]);

endmodule