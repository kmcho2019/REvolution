module nand4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // Explicit 4-input NAND implementation using a chain of 2-input nand gates for generic compatibility.
    // Some synthesis tools infer a 4-input NAND primitive from this.
    wire nand_ab;
    wire nand_cd;
    
    nand u1 (nand_ab, a, b);
    nand u2 (nand_cd, c, d);
    nand u3 (y, nand_ab, nand_cd);

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

    // Instantiate two 4-input NAND gates replicating the 7420 chip functionality
    nand4 u1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    nand4 u2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule