// Module: nand4
// Description: 4-input NAND gate replicating one gate of the 7420 dual NAND chip
module nand4 (
    input  a,    // First input
    input  b,    // Second input
    input  c,    // Third input
    input  d,    // Fourth input
    output y     // Output: NAND of all inputs
);
    // Perform 4-input NAND: output LOW only when all inputs are HIGH
    assign y = ~(a & b & c & d);
endmodule

// Module: TopModule
// Description: Dual 4-input NAND gates equivalent to 7420 chip
module TopModule (
    input  p1a,  // Inputs to first NAND gate
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Inputs to second NAND gate
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output of first NAND gate
    output p2y   // Output of second NAND gate
);

    // Instantiate first 4-input NAND gate
    nand4 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate
    nand4 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule