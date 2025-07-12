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

// Internal nets for first NAND gate
wire n1_1, n1_2;

// Build 4-input NAND for p1y using 2-input NANDs
nand (n1_1, p1a, p1b);   // NAND first pair
nand (n1_2, p1c, p1d);   // NAND second pair
nand (p1y, n1_1, n1_2);  // NAND outputs to get 4-input NAND

// Internal nets for second NAND gate
wire n2_1, n2_2;

// Build 4-input NAND for p2y using 2-input NANDs
nand (n2_1, p2a, p2b);   // NAND first pair
nand (n2_2, p2c, p2d);   // NAND second pair
nand (p2y, n2_1, n2_2);  // NAND outputs to get 4-input NAND

endmodule