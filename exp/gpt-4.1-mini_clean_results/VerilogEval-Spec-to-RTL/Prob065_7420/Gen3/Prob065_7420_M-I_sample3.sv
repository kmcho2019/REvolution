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

// Two independent 4-input NAND gates replicating the 7420 chip behavior.
// Output is low only when all inputs are high for each gate.
nand nand1 (p1y, p1a, p1b, p1c, p1d);
nand nand2 (p2y, p2a, p2b, p2c, p2d);

endmodule