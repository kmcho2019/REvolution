// Module: nand2
// Description: 2-input NAND gate primitive
module nand2(
    input  a,    // First input
    input  b,    // Second input
    output y     // NAND output
);
    assign y = ~(a & b);
endmodule

// Module: nand4_via_nand2
// Description: 4-input NAND gate implemented by combining three 2-input NAND gates
module nand4_via_nand2(
    input  a,    // First input
    input  b,    // Second input
    input  c,    // Third input
    input  d,    // Fourth input
    output y     // NAND output
);
    wire nand_ab, nand_cd;
    wire nand_mid;

    // First stage: NAND of (a,b) and (c,d)
    nand2 nand_gate1 (.a(a), .b(b), .y(nand_ab));
    nand2 nand_gate2 (.a(c), .b(d), .y(nand_cd));

    // Second stage: NAND of the two intermediate NAND outputs
    nand2 nand_gate3 (.a(nand_ab), .b(nand_cd), .y(nand_mid));

    // Third stage: NAND of nand_mid with nand_mid (double inversion)
    // This last stage converts the NAND of NANDs into the original NAND4 logic
    // Explanation: The final output is ~(~(a&b) & ~(c&d)) = NAND4 of all inputs.
    assign y = nand_mid;

endmodule

// Module: TopModule
// Description: 7420 chip emulation with two 4-input NAND gates built from 2-input NAND primitives
module TopModule(
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

    // Instantiate first 4-input NAND gate using nand2 hierarchy
    nand4_via_nand2 nand_gate1 (
        .a(p1a),
        .b(p1b),
        .c(p1c),
        .d(p1d),
        .y(p1y)
    );

    // Instantiate second 4-input NAND gate using nand2 hierarchy
    nand4_via_nand2 nand_gate2 (
        .a(p2a),
        .b(p2b),
        .c(p2c),
        .d(p2d),
        .y(p2y)
    );

endmodule