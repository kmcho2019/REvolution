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

    // Direct 4-input NAND for first set of inputs
    assign p1y = ~(p1a & p1b & p1c & p1d);

    // Direct 4-input NAND for second set of inputs
    assign p2y = ~(p2a & p2b & p2c & p2d);

endmodule