module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // First 4-input NAND (p1 group)
    wire p1_ab_nand, p1_cd_nand;
    nand(p1_ab_nand, p1a, p1b);
    nand(p1_cd_nand, p1c, p1d);
    nand(p1y, p1_ab_nand, p1_cd_nand);

    // Second 4-input NAND (p2 group)
    wire p2_ab_nand, p2_cd_nand;
    nand(p2_ab_nand, p2a, p2b);
    nand(p2_cd_nand, p2c, p2d);
    nand(p2y, p2_ab_nand, p2_cd_nand);
endmodule