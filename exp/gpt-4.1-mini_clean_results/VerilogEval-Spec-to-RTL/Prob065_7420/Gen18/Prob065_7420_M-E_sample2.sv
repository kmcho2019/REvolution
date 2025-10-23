// TopModule implementing two independent 4-input NAND gates (7420 chip equivalent)
// using flattened logic and intermediate wires for clarity.

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

    // Intermediate signals for AND of first set of inputs
    wire p1_and = p1a & p1b & p1c & p1d;

    // Intermediate signals for AND of second set of inputs
    wire p2_and = p2a & p2b & p2c & p2d;

    // NAND outputs are negations of the ANDs
    assign p1y = ~p1_and;
    assign p2y = ~p2_and;

endmodule