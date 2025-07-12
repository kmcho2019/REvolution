module nand4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // 4-input NAND gate: output is low only when all inputs are high
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

// Instantiate two independent 4-input NAND gates to replicate 7420 chip
nand4 nand_gate1 (
    .a(p1a),
    .b(p1b),
    .c(p1c),
    .d(p1d),
    .y(p1y)
);

nand4 nand_gate2 (
    .a(p2a),
    .b(p2b),
    .c(p2c),
    .d(p2d),
    .y(p2y)
);

endmodule