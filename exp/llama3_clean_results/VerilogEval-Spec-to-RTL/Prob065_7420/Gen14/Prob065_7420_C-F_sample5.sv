// Optimized modular approach for the NAND4 module
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Optimized implementation using basic logic gates
assign y = ~(a & b & c & d);
endmodule

// Optimized structure for the TopModule
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
// Instantiate two NAND4 modules for the two 4-input NAND gates
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