// Module implementing a single 4-input NAND gate, matching one half of the 7420 chip
module nand4 (
    input  a,
    input  b,
    input  c,
    input  d,
    output y
);
    // Direct 4-input NAND using bitwise AND and negation
    assign y = ~(a & b & c & d);
endmodule

// TopModule replicating the 7420 chip functionality with two independent 4-input NAND gates
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

    // Instantiate the first 4-input NAND gate
    nand4 nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate the second 4-input NAND gate
    nand4 nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule