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

    // Compute first AND group for p1 (3 inputs)
    wire p1_and1 = p1a & p1b & p1c;
    // Compute second AND group for p1 (3 inputs)
    wire p1_and2 = p1d & p1e & p1f;
    // OR of both AND groups for p1 output
    assign p1y = p1_and1 | p1_and2;

    // Compute first AND group for p2 (2 inputs)
    wire p2_and1 = p2a & p2b;
    // Compute second AND group for p2 (2 inputs)
    wire p2_and2 = p2c & p2d;
    // OR of both AND groups for p2 output
    assign p2y = p2_and1 | p2_and2;

endmodule