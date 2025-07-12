module TopModule(
    input  [3:0] in,
    output out_and,
    output out_or,
    output out_xor
);

    wire and_int1, and_int2;
    wire or_int1,  or_int2;
    wire xor_int1, xor_int2;

    // AND tree: (in[0] & in[1]) & (in[2] & in[3])
    and u_and1(and_int1, in[0], in[1]);
    and u_and2(and_int2, in[2], in[3]);
    and u_and3(out_and, and_int1, and_int2);

    // OR tree: (in[0] | in[1]) | (in[2] | in[3])
    or  u_or1(or_int1, in[0], in[1]);
    or  u_or2(or_int2, in[2], in[3]);
    or  u_or3(out_or, or_int1, or_int2);

    // XOR tree: (in[0] ^ in[1]) ^ (in[2] ^ in[3])
    xor u_xor1(xor_int1, in[0], in[1]);
    xor u_xor2(xor_int2, in[2], in[3]);
    xor u_xor3(out_xor, xor_int1, xor_int2);

endmodule