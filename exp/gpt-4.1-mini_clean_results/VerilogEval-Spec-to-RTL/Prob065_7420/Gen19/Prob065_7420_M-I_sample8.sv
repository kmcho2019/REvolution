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

// Use built-in 4-input NAND gate primitives for potentially optimal synthesis mapping
nand u_nand1 (p1y, p1a, p1b, p1c, p1d);
nand u_nand2 (p2y, p2a, p2b, p2c, p2d);

endmodule