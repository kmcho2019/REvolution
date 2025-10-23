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

    // Directly assign outputs as 4-input NAND of inputs, flattening the design
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule