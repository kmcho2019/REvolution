module TopModule (
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

    // First 4-input NAND (p1) implemented as tree
    wire p1_stage1_ab, p1_stage1_cd;
    nand(p1_stage1_ab, p1a, p1b);
    nand(p1_stage1_cd, p1c, p1d);
    nand(p1y, p1_stage1_ab, p1_stage1_cd);

    // Second 4-input NAND (p2) implemented as tree
    wire p2_stage1_ab, p2_stage1_cd;
    nand(p2_stage1_ab, p2a, p2b);
    nand(p2_stage1_cd, p2c, p2d);
    nand(p2y, p2_stage1_ab, p2_stage1_cd);

endmodule