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

    wire p1_nand_ab, p1_nand_cd, p1_and_abcd;
    wire p2_nand_ab, p2_nand_cd, p2_and_abcd;

    // First 4-input NAND gate implementation for p1y
    nand u1_p1 (p1_nand_ab, p1a, p1b);  // NAND of p1a and p1b
    nand u2_p1 (p1_nand_cd, p1c, p1d);  // NAND of p1c and p1d
    nand u3_p1 (p1_and_abcd, p1_nand_ab, p1_nand_cd); // NAND of the two intermediate outputs
    not  u4_p1 (p1y, p1_and_abcd);       // Invert to get NAND of all four inputs

    // Second 4-input NAND gate implementation for p2y
    nand u1_p2 (p2_nand_ab, p2a, p2b);  // NAND of p2a and p2b
    nand u2_p2 (p2_nand_cd, p2c, p2d);  // NAND of p2c and p2d
    nand u3_p2 (p2_and_abcd, p2_nand_ab, p2_nand_cd); // NAND of the two intermediate outputs
    not  u4_p2 (p2y, p2_and_abcd);       // Invert to get NAND of all four inputs

endmodule