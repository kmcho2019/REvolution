// Define the NAND2 module for a 2-input NAND gate
module NAND2(
    input  a,
    input  b,
    output y
);
// Implement the NAND logic using bitwise operators
assign y = ~(a & b);
endmodule

// Define the NAND4Tree module for a 4-input NAND gate using a tree structure of 2-input NAND gates
module NAND4Tree(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Intermediate signals for the tree structure
wire ab, cd;

// Implement the NAND logic using a tree of 2-input NAND gates
NAND2 nand_ab(
    .a(a),
    .b(b),
    .y(ab)
);

NAND2 nand_cd(
    .a(c),
    .b(d),
    .y(cd)
);

NAND2 nand_final(
    .a(ab),
    .b(cd),
    .y(y)
);
endmodule

// Define the TopModule that instantiates two NAND4Tree gates
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
// Instantiate two NAND4Tree gates for the 7420 chip's functionality
NAND4Tree nand1(
   .a(p1a),
   .b(p1b),
   .c(p1c),
   .d(p1d),
   .y(p1y)
);

NAND4Tree nand2(
   .a(p2a),
   .b(p2b),
   .c(p2c),
   .d(p2d),
   .y(p2y)
);
endmodule