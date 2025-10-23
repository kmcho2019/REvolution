module TopModule (
    input  p1a, p1b, p1c, p1d,
    input  p2a, p2b, p2c, p2d,
    output p1y,
    output p2y
);

    // Two independent 4-input NAND gates
    assign p1y = ~(& {p1a, p1b, p1c, p1d});
    assign p2y = ~(& {p2a, p2b, p2c, p2d});

endmodule