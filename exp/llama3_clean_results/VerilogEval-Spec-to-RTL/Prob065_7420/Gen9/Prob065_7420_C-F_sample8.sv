// Define the NAND4 module for a 4-input NAND gate
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Implement the NAND logic using bitwise operators
// This implementation is straightforward and likely to be optimized by synthesis tools
assign y = ~(a & b & c & d);
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
// Instantiate two NAND4 gates for the 7420 chip's functionality
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