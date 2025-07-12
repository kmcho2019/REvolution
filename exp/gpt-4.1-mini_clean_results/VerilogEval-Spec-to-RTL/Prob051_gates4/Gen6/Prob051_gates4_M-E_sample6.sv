module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);

    // Level 1: 2-input AND gates for input pairs
    wire and_0_1, and_2_3;
    and u_and0(and_0_1, in[0], in[1]);
    and u_and1(and_2_3, in[2], in[3]);

    // Level 2: 2-input AND gate to combine previous results
    and u_and2(out_and, and_0_1, and_2_3);

    // Level 1: 2-input OR gates for input pairs
    wire or_0_1, or_2_3;
    or u_or0(or_0_1, in[0], in[1]);
    or u_or1(or_2_3, in[2], in[3]);

    // Level 2: 2-input OR gate to combine previous results
    or u_or2(out_or, or_0_1, or_2_3);

    // Level 1: 2-input XOR gates for input pairs
    wire xor_0_1, xor_2_3;
    xor u_xor0(xor_0_1, in[0], in[1]);
    xor u_xor1(xor_2_3, in[2], in[3]);

    // Level 2: 2-input XOR gate to combine previous results
    xor u_xor2(out_xor, xor_0_1, xor_2_3);

endmodule