// TopModule implements two 4-input NAND gates (7420 chip) by decomposing each into three 2-input NAND gates
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

    wire p1_nand_ab, p1_nand_cd; // intermediate wires for first NAND gate inputs
    wire p2_nand_ab, p2_nand_cd; // intermediate wires for second NAND gate inputs

    // First 4-input NAND decomposition for p1y
    nand (p1_nand_ab, p1a, p1b);     // NAND of first two inputs
    nand (p1_nand_cd, p1c, p1d);     // NAND of last two inputs
    nand (p1y, p1_nand_ab, p1_nand_cd); // NAND of the two results -> equivalent to 4-input NAND

    // Second 4-input NAND decomposition for p2y
    nand (p2_nand_ab, p2a, p2b);     // NAND of first two inputs
    nand (p2_nand_cd, p2c, p2d);     // NAND of last two inputs
    nand (p2y, p2_nand_ab, p2_nand_cd); // NAND of the two results -> equivalent to 4-input NAND

endmodule