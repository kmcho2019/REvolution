// Balanced 4-input 2-input AND gate tree
module FourInputAnd (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;
    and u0(level1_0, in[0], in[1]);
    and u1(level1_1, in[2], in[3]);
    and u2(out,     level1_0, level1_1);
endmodule

// Balanced 4-input 2-input OR gate tree
module FourInputOr (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;
    or  u0(level1_0, in[0], in[1]);
    or  u1(level1_1, in[2], in[3]);
    or  u2(out,     level1_0, level1_1);
endmodule

// Balanced 4-input 2-input XOR gate tree
module FourInputXor (
    input  [3:0] in,
    output       out
);
    wire level1_0, level1_1;
    xor u0(level1_0, in[0], in[1]);
    xor u1(level1_1, in[2], in[3]);
    xor u2(out,     level1_0, level1_1);
endmodule

module TopModule (
    input  [3:0] in,
    output       out_and,
    output       out_or,
    output       out_xor
);
    // Intermediate signals to share level 1 gates to reduce load and switching activity
    wire and_l1_0, and_l1_1;
    wire or_l1_0,  or_l1_1;
    wire xor_l1_0, xor_l1_1;

    // First-level AND gates (shared only for AND)
    and u_and_0(and_l1_0, in[0], in[1]);
    and u_and_1(and_l1_1, in[2], in[3]);
    and u_and_out(out_and, and_l1_0, and_l1_1);

    // First-level OR gates (shared only for OR)
    or  u_or_0(or_l1_0, in[0], in[1]);
    or  u_or_1(or_l1_1, in[2], in[3]);
    or  u_or_out(out_or, or_l1_0, or_l1_1);

    // First-level XOR gates (shared only for XOR)
    xor u_xor_0(xor_l1_0, in[0], in[1]);
    xor u_xor_1(xor_l1_1, in[2], in[3]);
    xor u_xor_out(out_xor, xor_l1_0, xor_l1_1);
endmodule