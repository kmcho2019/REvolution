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

    // First 4-input NAND gate using primitive nand gates
    wire p1_and1, p1_and2;
    nand(p1_and1, p1a, p1b);
    nand(p1_and2, p1c, p1d);
    nand(p1y, p1_and1, p1_and2);

    // Second 4-input NAND gate using primitive nand gates
    wire p2_and1, p2_and2;
    nand(p2_and1, p2a, p2b);
    nand(p2_and2, p2c, p2d);
    nand(p2y, p2_and1, p2_and2);

endmodule