// Maintaining the current modular approach for clarity and simplicity.
module NAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// The current implementation is already optimized for basic logic synthesis.
// No changes are made here as the synthesis tool will handle optimizations.
assign y = ~(a & b & c & d);

endmodule

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
// Instantiating two NAND4 gates as per the 7420 chip's functionality.
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