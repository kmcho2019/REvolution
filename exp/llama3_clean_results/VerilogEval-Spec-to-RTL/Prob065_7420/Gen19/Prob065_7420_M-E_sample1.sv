module SimpleNAND2(
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

module NAND4_Decomposed(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire ab, cd;
    SimpleNAND2 nand_ab(
        .a(a),
        .b(b),
        .y(ab)
    );
    SimpleNAND2 nand_cd(
        .a(c),
        .b(d),
        .y(cd)
    );
    SimpleNAND2 nand_final(
        .a(ab),
        .b(cd),
        .y(y)
    );
endmodule

module TopModule_Decomposed(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);
    NAND4_Decomposed nand1(
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );
    NAND4_Decomposed nand2(
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );
endmodule