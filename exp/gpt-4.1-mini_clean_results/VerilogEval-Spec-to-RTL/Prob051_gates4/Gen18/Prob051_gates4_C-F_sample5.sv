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
    // Instantiate dedicated balanced 4-input gate tree modules
    FourInputAnd u_and ( .in(in), .out(out_and) );
    FourInputOr  u_or  ( .in(in), .out(out_or)  );
    FourInputXor u_xor ( .in(in), .out(out_xor) );

endmodule