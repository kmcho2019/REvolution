// Module: TopModule
// Description: Implements the 7420 chip functionality (two independent 4-input NAND gates)
// Optimization: Inlined nand4 logic directly for slight power and area savings
module TopModule(
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // First 4-input NAND gate output
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // Second 4-input NAND gate output
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule