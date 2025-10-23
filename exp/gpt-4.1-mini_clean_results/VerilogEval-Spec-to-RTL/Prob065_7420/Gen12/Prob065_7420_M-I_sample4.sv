// Module: nand2
// Description: 2-input NAND gate primitive
module nand2 (
    input  a,    // First input
    input  b,    // Second input
    output y     // NAND output
);
    assign y = ~(a & b);
endmodule

// Module: nand4
// Description: 4-input NAND gate built from three 2-input NAND gates
// Structure: y = NAND(NAND(a,b), NAND(c,d))
module nand4 (
    input  a,    // First input
    input  b,    // Second input
    input  c,    // Third input
    input  d,    // Fourth input
    output y     // NAND output
);
    wire n1, n2;

    // First level: two NAND2 gates
    nand2 u1 (.a(a), .b(b), .y(n1));
    nand2 u2 (.a(c), .b(d), .y(n2));

    // Second level: NAND2 of the two intermediate results
    nand2 u3 (.a(n1), .b(n2), .y(y));
endmodule

// Module: TopModule
// Description: Implements the 7420 chip functionality: two independent 4-input NAND gates
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