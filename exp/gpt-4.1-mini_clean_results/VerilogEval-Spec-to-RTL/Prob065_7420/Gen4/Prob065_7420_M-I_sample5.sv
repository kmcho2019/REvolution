module nand4_2level (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire nand_ab, nand_cd;

    // First level: NAND of pairs
    nand (nand_ab, a, b);
    nand (nand_cd, c, d);

    // Second level: NAND of the first level outputs
    nand (y, nand_ab, nand_cd);
endmodule

module TopModule(
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

// Instantiate two hierarchical 4-input NAND gates 
nand4_2level u1 (
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

nand4_2level u2 (
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);

endmodule