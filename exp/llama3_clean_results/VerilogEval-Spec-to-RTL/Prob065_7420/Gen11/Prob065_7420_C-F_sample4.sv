// Define a reusable module for a 4-input NAND gate with optimized implementation
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);

// Assign y as the negation of the conjunction of a, b, c, and d
assign y = ~(a & b & c & d);

endmodule

// Instantiate the NAND4 module twice within the TopModule
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

// Instantiate NAND4 modules for the first and second sets of inputs
NAND4 nand1(
 .a(p1a),
 .b(p1b),
 .c(p1c),
 .d(p1d),
 .y(p1y)
);

NAND4 nand2(
 .a(p2a),
 .b(p2b),
 .c(p2c),
 .d(p2d),
 .y(p2y)
);

endmodule