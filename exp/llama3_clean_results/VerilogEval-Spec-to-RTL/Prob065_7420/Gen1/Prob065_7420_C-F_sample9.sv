// Module TopModule implements the functionality of the 7420 chip with two 4-input NAND gates.
module TopModule(
    input  p1a,  // Input for the first 4-input NAND gate
    input  p1b,  // Input for the first 4-input NAND gate
    input  p1c,  // Input for the first 4-input NAND gate
    input  p1d,  // Input for the first 4-input NAND gate
    input  p2a,  // Input for the second 4-input NAND gate
    input  p2b,  // Input for the second 4-input NAND gate
    input  p2c,  // Input for the second 4-input NAND gate
    input  p2d,  // Input for the second 4-input NAND gate
    output p1y,  // Output of the first 4-input NAND gate
    output p2y   // Output of the second 4-input NAND gate
);

// Implement the first 4-input NAND gate by performing a logical AND operation on all inputs and then inverting the result.
assign p1y = ~(p1a & p1b & p1c & p1d);

// Implement the second 4-input NAND gate in the same manner as the first one.
assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule