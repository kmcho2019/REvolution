module nand2 (
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

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

    // Intermediate wires for first 4-input NAND (p1 inputs)
    wire p1_nand_ab, p1_nand_cd;
    // Intermediate wires for second 4-input NAND (p2 inputs)
    wire p2_nand_ab, p2_nand_cd;

    // First 4-input NAND gate (p1y)
    nand2 u1a (.a(p1a), .b(p1b), .y(p1_nand_ab));
    nand2 u1b (.a(p1c), .b(p1d), .y(p1_nand_cd));
    nand2 u1c (.a(p1_nand_ab), .b(p1_nand_cd), .y(p1y));

    // Second 4-input NAND gate (p2y)
    nand2 u2a (.a(p2a), .b(p2b), .y(p2_nand_ab));
    nand2 u2b (.a(p2c), .b(p2d), .y(p2_nand_cd));
    nand2 u2c (.a(p2_nand_ab), .b(p2_nand_cd), .y(p2y));

endmodule