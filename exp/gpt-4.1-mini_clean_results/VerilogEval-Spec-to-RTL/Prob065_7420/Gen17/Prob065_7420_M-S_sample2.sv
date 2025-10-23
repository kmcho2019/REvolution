// Module: TopModule
// Description: Implements two independent 4-input NAND gates as in the 7420 chip
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

    // Direct 4-input NAND gates as continuous assignments
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule