module TopModule(
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Intermediate wires for gate outputs
    wire and1_out, and2_out;
    wire or1_out, or2_out;
    wire xor1_out, xor2_out;

    // First level of 2-input gates
    and and1(and1_out, in[0], in[1]);
    and and2(and2_out, in[2], in[3]);
    or  or1(or1_out, in[0], in[1]);
    or  or2(or2_out, in[2], in[3]);
    xor xor1(xor1_out, in[0], in[1]);
    xor xor2(xor2_out, in[2], in[3]);

    // Second level combining first level outputs
    and and_final(out_and, and1_out, and2_out);
    or  or_final(out_or, or1_out, or2_out);
    xor xor_final(out_xor, xor1_out, xor2_out);

endmodule