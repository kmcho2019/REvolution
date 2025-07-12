module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    wire and0, and1;
    wire or0, or1;
    wire xor0, xor1;

    // AND tree: two 2-input ANDs, then one final AND
    and and_gate0(and0, in[0], in[1]);
    and and_gate1(and1, in[2], in[3]);
    and and_gate_final(out_and, and0, and1);

    // OR tree: two 2-input ORs, then one final OR
    or or_gate0(or0, in[0], in[1]);
    or or_gate1(or1, in[2], in[3]);
    or or_gate_final(out_or, or0, or1);

    // XOR tree: two 2-input XORs, then one final XOR
    xor xor_gate0(xor0, in[0], in[1]);
    xor xor_gate1(xor1, in[2], in[3]);
    xor xor_gate_final(out_xor, xor0, xor1);

endmodule