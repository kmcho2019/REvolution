// Module: TopModule
// Description: Implements two 4-input NAND gates (like 7420 chip) using direct continuous assignments
module TopModule (
    input  p1a,  // Inputs for first NAND gate
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,  // Inputs for second NAND gate
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,  // Output of first 4-input NAND gate
    output p2y   // Output of second 4-input NAND gate
);

    // Output p1y is the NAND of inputs p1a, p1b, p1c, and p1d
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // Output p2y is the NAND of inputs p2a, p2b, p2c, and p2d
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule