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

// Intermediate wires for p1 NAND gate
wire p1_n1, p1_n2, p1_n3;
// Intermediate wires for p2 NAND gate
wire p2_n1, p2_n2, p2_n3;

// Build 4-input NAND for p1y using 2-input NANDs
nand (p1_n1, p1a, p1b);     // NAND first pair
nand (p1_n2, p1c, p1d);     // NAND second pair
nand (p1_n3, p1_n1, p1_n2); // NAND outputs of first two NANDs
nand (p1y, p1_n3, p1_n3);   // NAND with itself to invert again, producing 4-input NAND

// Build 4-input NAND for p2y using 2-input NANDs
nand (p2_n1, p2a, p2b);     // NAND first pair
nand (p2_n2, p2c, p2d);     // NAND second pair
nand (p2_n3, p2_n1, p2_n2); // NAND outputs of first two NANDs
nand (p2y, p2_n3, p2_n3);   // NAND with itself to invert again, producing 4-input NAND

endmodule