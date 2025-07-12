module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    // Intermediate wires for two-input gates
    wire and_0_1, and_2_3;
    wire or_0_1,  or_2_3;
    wire xor_0_1, xor_2_3;

    // Two-input AND gates stage 1
    and u_and0(and_0_1, in[0], in[1]);
    and u_and1(and_2_3, in[2], in[3]);
    // Two-input AND gate stage 2 (final)
    and u_and2(out_and, and_0_1, and_2_3);

    // Two-input OR gates stage 1
    or  u_or0(or_0_1, in[0], in[1]);
    or  u_or1(or_2_3, in[2], in[3]);
    // Two-input OR gate stage 2 (final)
    or  u_or2(out_or, or_0_1, or_2_3);

    // Two-input XOR gates stage 1
    xor u_xor0(xor_0_1, in[0], in[1]);
    xor u_xor1(xor_2_3, in[2], in[3]);
    // Two-input XOR gate stage 2 (final)
    xor u_xor2(out_xor, xor_0_1, xor_2_3);

endmodule