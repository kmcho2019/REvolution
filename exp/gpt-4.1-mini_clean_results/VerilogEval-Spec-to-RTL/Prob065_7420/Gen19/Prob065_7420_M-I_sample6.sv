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

// Instantiate two 4-input NAND gates directly using built-in nand primitive
// Chained nand to implement 4-input NAND: nand(a, b, c, d)
nand (p1y, p1a, p1b, p1c, p1d);
nand (p2y, p2a, p2b, p2c, p2d);

endmodule