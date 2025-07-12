// Module: nand4
// Description: 4-input NAND gate replicating one of the two 4-input NAND gates in the 7420 chip
(* keep = "true" *)  // Suggest to synthesis tools to preserve this as a distinct gate if supported
module nand4 (
    input  wire a,  // Input bit 1
    input  wire b,  // Input bit 2
    input  wire c,  // Input bit 3
    input  wire d,  // Input bit 4
    output wire y   // Output bit: NAND of all four inputs
);
    // Direct NAND assignment using bitwise AND and negation
    assign y = ~(a & b & c & d);
endmodule

// Module: TopModule
// Description: Implements the 7420 chip functionality by instantiating two independent 4-input NAND gates
module TopModule (
    input  wire p1a,  // Inputs for first NAND gate
    input  wire p1b,
    input  wire p1c,
    input  wire p1d,
    input  wire p2a,  // Inputs for second NAND gate
    input  wire p2b,
    input  wire p2c,
    input  wire p2d,
    output wire p1y,  // Output from first NAND gate
    output wire p2y   // Output from second NAND gate
);

    // Instantiate first 4-input NAND gate
    nand4 u_nand1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate
    nand4 u_nand2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule