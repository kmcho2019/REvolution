module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Balanced 4-input AND using 2-input AND gates
    wire and_0, and_1;
    and u_and0(and_0, in[0], in[1]);
    and u_and1(and_1, in[2], in[3]);
    and u_and2(out_and, and_0, and_1);

    // Balanced 4-input OR using 2-input OR gates
    wire or_0, or_1;
    or  u_or0(or_0, in[0], in[1]);
    or  u_or1(or_1, in[2], in[3]);
    or  u_or2(out_or, or_0, or_1);

    // Balanced 4-input XOR using 2-input XOR gates
    wire xor_0, xor_1;
    xor u_xor0(xor_0, in[0], in[1]);
    xor u_xor1(xor_1, in[2], in[3]);
    xor u_xor2(out_xor, xor_0, xor_1);
endmodule