// 4-input NAND gate module replicating one NAND gate of 7420 chip
module nand4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // Output is low only when all inputs are high
    assign y = ~(a & b & c & d);
endmodule

// TopModule implements two independent 4-input NAND gates (7420 chip functionality)
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

    // Instantiate first 4-input NAND gate (first half of 7420)
    nand4 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate (second half of 7420)
    nand4 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule