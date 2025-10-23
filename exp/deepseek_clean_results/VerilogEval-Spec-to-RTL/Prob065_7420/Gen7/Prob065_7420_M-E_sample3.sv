module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First 4-input NAND gate implementation
    wire p1_nand_ab, p1_nand_cd;
    nand(p1_nand_ab, p1a, p1b);
    nand(p1_nand_cd, p1c, p1d);
    nand(p1y, p1_nand_ab, p1_nand_cd);

    // Second 4-input NAND gate implementation
    wire p2_nand_ab, p2_nand_cd;
    nand(p2_nand_ab, p2a, p2b);
    nand(p2_nand_cd, p2c, p2d);
    nand(p2y, p2_nand_ab, p2_nand_cd);
endmodule