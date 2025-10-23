// Define an optimized module for a 4-input NAND gate
module OptimalNAND4(
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
// Implement the NAND operation using a single line of code for simplicity and efficiency
assign y = ~(a & b & c & d);
endmodule

// Instantiate the OptimalNAND4 module twice within the TopModule
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
// Instantiate OptimalNAND4 modules for the first and second sets of inputs
OptimalNAND4 nand1(
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

OptimalNAND4 nand2(
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);
endmodule