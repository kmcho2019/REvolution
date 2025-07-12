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

    // First 4-input NAND gate implemented as three 2-input NAND gates
    wire p1n1, p1n2;
    nand u1a(p1n1, p1a, p1b);
    nand u1b(p1n2, p1c, p1d);
    nand u1y(p1y, p1n1, p1n2);

    // Second 4-input NAND gate implemented similarly
    wire p2n1, p2n2;
    nand u2a(p2n1, p2a, p2b);
    nand u2b(p2n2, p2c, p2d);
    nand u2y(p2y, p2n1, p2n2);

endmodule