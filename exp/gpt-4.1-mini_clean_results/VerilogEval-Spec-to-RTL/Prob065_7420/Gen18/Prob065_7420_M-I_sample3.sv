module nand4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // Implement 4-input NAND using only 2-input nand primitives:
    // y = ~(a & b & c & d) = nand(nand(a,b), nand(c,d))
    wire ab_nand, cd_nand;

    nand u1 (ab_nand, a, b);
    nand u2 (cd_nand, c, d);
    nand u3 (y, ab_nand, cd_nand);
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

// Instantiate two independent 4-input NAND gates replicating 7420 functionality
nand4 u_nand1 (
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

nand4 u_nand2 (
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);

endmodule