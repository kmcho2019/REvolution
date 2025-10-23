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

// Intermediate nets for p1 NAND gate inputs
wire p1_ab_nand;
wire p1_cd_nand;

// Intermediate nets for p2 NAND gate inputs
wire p2_ab_nand;
wire p2_cd_nand;

// Construct first 4-input NAND gate for p1y
nand u1_p1_ab (p1_ab_nand, p1a, p1b);
nand u2_p1_cd (p1_cd_nand, p1c, p1d);
nand u3_p1_y  (p1y, p1_ab_nand, p1_cd_nand);

// Construct second 4-input NAND gate for p2y
nand u1_p2_ab (p2_ab_nand, p2a, p2b);
nand u2_p2_cd (p2_cd_nand, p2c, p2d);
nand u3_p2_y  (p2y, p2_ab_nand, p2_cd_nand);

endmodule