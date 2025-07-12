// Define a basic 2-input NAND gate module
module NAND2(
    input  a,
    input  b,
    output y
);
    assign y = ~(a & b);
endmodule

// Define a 4-input NAND gate module using the NAND2 gate
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    wire ab, cd;
    NAND2 nand_ab(a, b, ab);
    NAND2 nand_cd(c, d, cd);
    NAND2 nand_y(ab, cd, y);
endmodule

// Define the TopModule that instantiates two NAND4 gates
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
    // Instantiate two NAND4 gates
    NAND4 nand_p1(p1a, p1b, p1c, p1d, p1y);
    NAND4 nand_p2(p2a, p2b, p2c, p2d, p2y);
endmodule