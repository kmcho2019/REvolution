// TopModule replicates the 7420 chip functionality containing two independent 4-input NAND gates
// Each 4-input NAND gate is implemented with two stages of 2-input NAND gates to optimize delay and power
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

    // Intermediate wires for first 4-input NAND gate (p1 inputs)
    wire p1_nand_ab;
    wire p1_nand_cd;

    // First stage: NAND the input pairs for p1
    nand u1_1 (p1_nand_ab, p1a, p1b);
    nand u1_2 (p1_nand_cd, p1c, p1d);

    // Second stage: NAND the outputs of first stage to get 4-input NAND functionality
    nand u1_3 (p1y, p1_nand_ab, p1_nand_cd);


    // Intermediate wires for second 4-input NAND gate (p2 inputs)
    wire p2_nand_ab;
    wire p2_nand_cd;

    // First stage: NAND the input pairs for p2
    nand u2_1 (p2_nand_ab, p2a, p2b);
    nand u2_2 (p2_nand_cd, p2c, p2d);

    // Second stage: NAND the outputs of first stage to get 4-input NAND functionality
    nand u2_3 (p2y, p2_nand_ab, p2_nand_cd);

endmodule