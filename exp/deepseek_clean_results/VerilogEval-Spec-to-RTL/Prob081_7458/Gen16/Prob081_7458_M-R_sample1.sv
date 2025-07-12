module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // p1y is OR of two 3-input ANDs
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);
    
    // p2y is OR of two 2-input ANDs
    assign p2y = (p2a & p2b) | (p2c & p2d);

endmodule