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

    // Directly compute ANDs for p1 groups
    wire p1_and1 = p1a & p1b & p1c;
    wire p1_and2 = p1d & p1e & p1f;

    // Directly compute ANDs for p2 groups
    wire p2_and1 = p2a & p2b;
    wire p2_and2 = p2c & p2d;

    // OR the AND gate outputs to produce final outputs
    assign p1y = p1_and1 | p1_and2;
    assign p2y = p2_and1 | p2_and2;

endmodule