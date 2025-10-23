module TopModule (
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

    // Internal wires for first 4-input NAND gate (p1)
    wire p1_nand1, p1_nand2;

    // Internal wires for second 4-input NAND gate (p2)
    wire p2_nand1, p2_nand2;

    // 4-input NAND for p1: ((p1a NAND p1b) NAND (p1c NAND p1d))
    nand u1_p1_nand1 (p1_nand1, p1a, p1b);
    nand u2_p1_nand2 (p1_nand2, p1c, p1d);
    nand u3_p1y       (p1y,     p1_nand1, p1_nand2);

    // 4-input NAND for p2: ((p2a NAND p2b) NAND (p2c NAND p2d))
    nand u4_p2_nand1 (p2_nand1, p2a, p2b);
    nand u5_p2_nand2 (p2_nand2, p2c, p2d);
    nand u6_p2y       (p2y,     p2_nand1, p2_nand2);

endmodule