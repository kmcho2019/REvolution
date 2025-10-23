// Module: nand4
// Description: A 4-input NAND gate replicating one NAND gate of the 7420 chip
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

// Module: TopModule
// Description: Implements the functionality of the 7420 chip with two independent 4-input NAND gates
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
    nand4 u_nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate (second half of 7420)
    nand4 u_nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule