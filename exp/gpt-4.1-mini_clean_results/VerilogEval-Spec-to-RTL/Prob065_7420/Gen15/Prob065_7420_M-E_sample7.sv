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

    // Intermediate wires for first 4-input NAND
    wire p1_nand_ab;
    wire p1_nand_cd;
    // Intermediate wires for second 4-input NAND
    wire p2_nand_ab;
    wire p2_nand_cd;

    // First 4-input NAND gate built from three 2-input NANDs
    nand (p1_nand_ab, p1a, p1b);   // NAND of first two inputs
    nand (p1_nand_cd, p1c, p1d);   // NAND of last two inputs
    nand (p1y, p1_nand_ab, p1_nand_cd); // NAND of the two results to form 4-input NAND

    // Second 4-input NAND gate similarly built
    nand (p2_nand_ab, p2a, p2b);
    nand (p2_nand_cd, p2c, p2d);
    nand (p2y, p2_nand_ab, p2_nand_cd);

endmodule