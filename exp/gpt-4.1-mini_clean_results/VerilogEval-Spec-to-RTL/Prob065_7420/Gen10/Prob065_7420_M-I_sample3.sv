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

    wire p1_nand_ab, p1_nand_cd;
    wire p2_nand_ab, p2_nand_cd;

    // First 4-input NAND gate implementation for p1y (7420 style)
    nand (p1_nand_ab, p1a, p1b);
    nand (p1_nand_cd, p1c, p1d);
    nand (p1y, p1_nand_ab, p1_nand_cd);

    // Second 4-input NAND gate implementation for p2y (7420 style)
    nand (p2_nand_ab, p2a, p2b);
    nand (p2_nand_cd, p2c, p2d);
    nand (p2y, p2_nand_ab, p2_nand_cd);

endmodule