module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Directly assign p1y as OR of two 3-input AND terms
    assign p1y = (p1a & p1b & p1c) | (p1d & p1e & p1f);

    // Directly assign p2y as OR of two 2-input AND terms
    assign p2y = (p2a & p2b) | (p2c & p2d);

endmodule