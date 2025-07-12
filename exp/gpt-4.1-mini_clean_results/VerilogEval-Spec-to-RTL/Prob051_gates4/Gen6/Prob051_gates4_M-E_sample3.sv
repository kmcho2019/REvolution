module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Intermediate wires for AND gates
    wire and_level1_0, and_level1_1;
    // Intermediate wires for OR gates
    wire or_level1_0, or_level1_1;
    // Intermediate wires for XOR gates
    wire xor_level1_0, xor_level1_1;

    // AND gate tree
    and u_and0 (and_level1_0, in[0], in[1]);
    and u_and1 (and_level1_1, in[2], in[3]);
    and u_and2 (out_and,   and_level1_0, and_level1_1);

    // OR gate tree
    or u_or0 (or_level1_0, in[0], in[1]);
    or u_or1 (or_level1_1, in[2], in[3]);
    or u_or2 (out_or,     or_level1_0, or_level1_1);

    // XOR gate tree
    xor u_xor0 (xor_level1_0, in[0], in[1]);
    xor u_xor1 (xor_level1_1, in[2], in[3]);
    xor u_xor2 (out_xor,    xor_level1_0, xor_level1_1);

endmodule