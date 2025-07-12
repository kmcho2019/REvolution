// Module: TopModule
// Description: Implements the 7420 chip functionality - two independent 4-input NAND gates
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

    // Direct 4-input NAND logic for first gate
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // Direct 4-input NAND logic for second gate
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule