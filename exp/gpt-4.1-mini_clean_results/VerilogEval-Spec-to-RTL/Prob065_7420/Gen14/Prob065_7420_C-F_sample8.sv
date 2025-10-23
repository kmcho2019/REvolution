// Module: nand4
// Description: 4-input NAND gate replicating one of the two 4-input NAND gates in the 7420 chip
module nand4 (
    input  a,  // Input bit 1
    input  b,  // Input bit 2
    input  c,  // Input bit 3
    input  d,  // Input bit 4
    output y   // Output bit: NAND of all four inputs
);
    // Assign NAND logic using built-in bitwise AND and negation operators
    assign y = ~(a & b & c & d);
endmodule

// Module: TopModule
// Description: Top-level module implementing the 7420 chip functionality with two 4-input NAND gates
module TopModule (
    input  p1a,  // Inputs for first NAND gate
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Inputs for second NAND gate
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output from first NAND gate
    output p2y   // Output from second NAND gate
);

    // Instantiate first 4-input NAND gate with synthesis preservation attribute
    (* keep = "true" *) nand4 u_nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate with synthesis preservation attribute
    (* keep = "true" *) nand4 u_nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule