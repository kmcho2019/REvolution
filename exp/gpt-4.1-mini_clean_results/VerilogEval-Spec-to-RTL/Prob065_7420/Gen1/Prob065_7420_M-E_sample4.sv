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

    wire p1_nand_ab, p1_nand_cd;
    wire p2_nand_ab, p2_nand_cd;

    // First stage: NAND pairs of inputs
    assign p1_nand_ab = ~(p1a & p1b);
    assign p1_nand_cd = ~(p1c & p1d);
    assign p2_nand_ab = ~(p2a & p2b);
    assign p2_nand_cd = ~(p2c & p2d);

    // Second stage: NAND the intermediate signals
    assign p1y = ~(p1_nand_ab & p1_nand_cd);
    assign p2y = ~(p2_nand_ab & p2_nand_cd);

endmodule