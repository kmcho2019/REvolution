module TopModule (
    input  p1a, p1b, p1c, p1d,  // First NAND inputs
    input  p2a, p2b, p2c, p2d,  // Second NAND inputs
    output p1y, p2y             // Outputs
);

    // First 4-input NAND implemented as tree of 2-input NANDs
    wire p1_ab, p1_cd;
    nand(p1_ab, p1a, p1b);
    nand(p1_cd, p1c, p1d);
    wire p1_abcd;
    nand(p1_abcd, p1_ab, p1_cd);
    nand(p1y, p1_abcd, p1_abcd);  // Final inversion

    // Second 4-input NAND implemented as tree of 2-input NANDs
    wire p2_ab, p2_cd;
    nand(p2_ab, p2a, p2b);
    nand(p2_cd, p2c, p2d);
    wire p2_abcd;
    nand(p2_abcd, p2_ab, p2_cd);
    nand(p2y, p2_abcd, p2_abcd);  // Final inversion

endmodule