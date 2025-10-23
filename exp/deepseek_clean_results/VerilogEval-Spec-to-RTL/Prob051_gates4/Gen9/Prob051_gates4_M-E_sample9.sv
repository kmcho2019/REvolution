module TopModule(
    input  wire [3:0] in,
    output wire       out_and,
    output wire       out_or,
    output wire       out_xor
);

    // Intermediate wires for AND tree
    wire and_level1_0, and_level1_1;
    wire and_level2;

    // Intermediate wires for OR tree
    wire or_level1_0, or_level1_1;
    wire or_level2;

    // Intermediate wires for XOR chain
    wire xor_level1, xor_level2;

    // AND gate tree implementation
    and G1_and(and_level1_0, in[0], in[1]);
    and G2_and(and_level1_1, in[2], in[3]);
    and G3_and(and_level2, and_level1_0, and_level1_1);
    assign out_and = and_level2;

    // OR gate tree implementation
    or G1_or(or_level1_0, in[0], in[1]);
    or G2_or(or_level1_1, in[2], in[3]);
    or G3_or(or_level2, or_level1_0, or_level1_1);
    assign out_or = or_level2;

    // XOR chain implementation (must be sequential for correct functionality)
    xor G1_xor(xor_level1, in[0], in[1]);
    xor G2_xor(xor_level2, xor_level1, in[2]);
    xor G3_xor(out_xor, xor_level2, in[3]);

endmodule