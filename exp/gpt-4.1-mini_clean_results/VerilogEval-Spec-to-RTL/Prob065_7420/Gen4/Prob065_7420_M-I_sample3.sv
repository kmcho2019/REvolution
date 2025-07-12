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

    // Implement two 4-input NAND gates using two levels of 2-input NAND gates

    wire p1_n1, p1_n2;
    wire p2_n1, p2_n2;

    // First level: NAND pairs of inputs for p1
    nand (p1_n1, p1a, p1b);
    nand (p1_n2, p1c, p1d);
    // Second level: NAND of previous NAND outputs for p1
    nand (p1y, p1_n1, p1_n2);

    // First level: NAND pairs of inputs for p2
    nand (p2_n1, p2a, p2b);
    nand (p2_n2, p2c, p2d);
    // Second level: NAND of previous NAND outputs for p2
    nand (p2y, p2_n1, p2_n2);

endmodule