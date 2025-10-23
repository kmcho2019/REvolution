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

wire and1_p1;
wire and2_p1;
wire and1_p2;
wire and2_p2;

// 4-input NAND implemented as NAND of two NANDs to leverage 2-input NAND primitives:
// NAND4(a,b,c,d) = NAND(NAND(a,b), NAND(c,d))

// First NAND gate outputs
wire nand_ab_p1;
wire nand_cd_p1;

nand u_nand_ab_p1(nand_ab_p1, p1a, p1b);
nand u_nand_cd_p1(nand_cd_p1, p1c, p1d);
nand u_nand4_p1(p1y, nand_ab_p1, nand_cd_p1);

// Second NAND gate outputs
wire nand_ab_p2;
wire nand_cd_p2;

nand u_nand_ab_p2(nand_ab_p2, p2a, p2b);
nand u_nand_cd_p2(nand_cd_p2, p2c, p2d);
nand u_nand4_p2(p2y, nand_ab_p2, nand_cd_p2);

endmodule