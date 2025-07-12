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

wire n1_p1, n2_p1, n3_p1;
wire n1_p2, n2_p2, n3_p2;

// First 4-input NAND gate (p1y) implemented using a chain of 2-input nand gates
nand u1_p1 (n1_p1, p1a, p1b);    // nand of first two inputs
nand u2_p1 (n2_p1, p1c, p1d);    // nand of last two inputs
nand u3_p1 (p1y, n1_p1, n2_p1);  // nand of previous nand outputs

// Second 4-input NAND gate (p2y) implemented similarly
nand u1_p2 (n1_p2, p2a, p2b);
nand u2_p2 (n2_p2, p2c, p2d);
nand u3_p2 (p2y, n1_p2, n2_p2);

endmodule