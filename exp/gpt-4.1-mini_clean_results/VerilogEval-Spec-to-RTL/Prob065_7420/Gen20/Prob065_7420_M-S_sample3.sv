// Module: TopModule
// Description: Implements two independent 4-input NAND gates (7420 chip functionality)
module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);
    // Direct 4-input NAND gate logic for first gate
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // Direct 4-input NAND gate logic for second gate
    assign p2y = ~(p2a & p2b & p2c & p2d);
endmodule