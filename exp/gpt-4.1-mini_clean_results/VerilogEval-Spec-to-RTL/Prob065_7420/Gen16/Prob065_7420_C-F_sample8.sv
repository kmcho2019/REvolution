// Module: nand4
// Description: 4-input NAND gate replicating one of the two independent gates in the 7420 chip
module nand4 (
    input  a,  // First input
    input  b,  // Second input
    input  c,  // Third input
    input  d,  // Fourth input
    output y   // NAND output (LOW only when all inputs are HIGH)
);
    // Implement 4-input NAND using bitwise AND and negation operators for synthesis efficiency
    assign y = ~(a & b & c & d);
endmodule

// Module: TopModule
// Description: Top-level module implementing two independent 4-input NAND gates as in the 7420 chip
module TopModule (
    input  p1a,  // First input of first NAND gate
    input  p1b,  // Second input of first NAND gate
    input  p1c,  // Third input of first NAND gate
    input  p1d,  // Fourth input of first NAND gate
    input  p2a,  // First input of second NAND gate
    input  p2b,  // Second input of second NAND gate
    input  p2c,  // Third input of second NAND gate
    input  p2d,  // Fourth input of second NAND gate
    output p1y,  // Output of first NAND gate
    output p2y   // Output of second NAND gate
);

    // Instantiate first 4-input NAND gate with synthesis attribute to preserve gate structure
    (* keep = "true" *) nand4 u_nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate with synthesis attribute to preserve gate structure
    (* keep = "true" *) nand4 u_nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule