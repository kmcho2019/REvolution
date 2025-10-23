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

    // First 4-input NAND gate implementation
    wire p1_stage1, p1_stage2;
    nand(p1_stage1, p1a, p1b);
    nand(p1_stage2, p1c, p1d);
    nand(p1y, p1_stage1, p1_stage2);

    // Second 4-input NAND gate implementation
    wire p2_stage1, p2_stage2;
    nand(p2_stage1, p2a, p2b);
    nand(p2_stage2, p2c, p2d);
    nand(p2y, p2_stage1, p2_stage2);

endmodule