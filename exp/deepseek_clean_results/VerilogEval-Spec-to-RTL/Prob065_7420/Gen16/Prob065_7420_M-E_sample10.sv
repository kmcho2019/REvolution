module TopModule (
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // First 4-input NAND implemented as tree of 2-input NANDs
    wire nand1_ab, nand1_cd;
    nand(nand1_ab, p1a, p1b);
    nand(nand1_cd, p1c, p1d);
    nand(p1y, nand1_ab, nand1_cd);

    // Second 4-input NAND implemented as tree of 2-input NANDs
    wire nand2_ab, nand2_cd;
    nand(nand2_ab, p2a, p2b);
    nand(nand2_cd, p2c, p2d);
    nand(p2y, nand2_ab, nand2_cd);

endmodule