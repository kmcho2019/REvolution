module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // LUT for p1y (6 inputs)
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);

    // LUT for p2y (4 inputs)
    assign p2y = (p2a & p2b) | (p2c & p2d);

endmodule