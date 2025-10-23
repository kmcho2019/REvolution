// Module: TopModule
// Description: Implements the functionality of the 7420 chip with two independent 4-input NAND gates
// This version flattens the design by removing the nand4 module and directly expressing NAND logic
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

    // Direct 4-input NAND gates implemented using reduction AND and inversion
    assign p1y = ~(p1a & p1b & p1c & p1d);
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule