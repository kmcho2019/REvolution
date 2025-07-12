module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Intermediate wires for AND tree
    wire and_01, and_23;
    and and_gate1(and_01, in[0], in[1]);
    and and_gate2(and_23, in[2], in[3]);
    and and_final(out_and, and_01, and_23);

    // Intermediate wires for OR tree
    wire or_01, or_23;
    or or_gate1(or_01, in[0], in[1]);
    or or_gate2(or_23, in[2], in[3]);
    or or_final(out_or, or_01, or_23);

    // Intermediate wires for XOR tree
    wire xor_01, xor_23;
    xor xor_gate1(xor_01, in[0], in[1]);
    xor xor_gate2(xor_23, in[2], in[3]);
    xor xor_final(out_xor, xor_01, xor_23);

endmodule