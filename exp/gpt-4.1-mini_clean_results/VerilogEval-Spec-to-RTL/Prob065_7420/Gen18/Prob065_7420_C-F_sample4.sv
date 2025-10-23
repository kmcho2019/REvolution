// Module: nand4
// Description: 4-input NAND gate replicating one of the two NAND gates in the 7420 chip
module nand4 (
    input  a,  // First input
    input  b,  // Second input
    input  c,  // Third input
    input  d,  // Fourth input
    output y   // NAND output: LOW only if all inputs are HIGH
);
    // Synthesis-friendly assignment of NAND logic
    assign y = ~(a & b & c & d);
endmodule

// Module: TopModule
// Description: Implements the 7420 chip functionality consisting of two independent 4-input NAND gates
module TopModule (
    input  p1a,  // Inputs for first NAND gate
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Inputs for second NAND gate
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output of first NAND gate
    output p2y   // Output of second NAND gate
);

    // Instantiate first 4-input NAND gate (first half of the 7420)
    (* keep = "true" *) nand4 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate (second half of the 7420)
    (* keep = "true" *) nand4 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule