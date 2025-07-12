// Module: TopModule
// Description: Implements the 7420 chip functionality using only 2-input NAND gates
module TopModule(
    input  p1a,  // Inputs for first 4-input NAND gate
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Inputs for second 4-input NAND gate
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output of first 4-input NAND gate
    output p2y   // Output of second 4-input NAND gate
);
    // Intermediate wires for first NAND gate
    wire nand1_p1, nand2_p1;

    // First 4-input NAND gate decomposition:
    // Level 1 NANDs
    nand (nand1_p1, p1a, p1b);
    nand (nand2_p1, p1c, p1d);
    // Level 2 NAND: NAND of the outputs of level 1 NANDs
    nand (p1y, nand1_p1, nand2_p1);

    // Intermediate wires for second NAND gate
    wire nand1_p2, nand2_p2;

    // Second 4-input NAND gate decomposition:
    // Level 1 NANDs
    nand (nand1_p2, p2a, p2b);
    nand (nand2_p2, p2c, p2d);
    // Level 2 NAND: NAND of the outputs of level 1 NANDs
    nand (p2y, nand1_p2, nand2_p2);

endmodule