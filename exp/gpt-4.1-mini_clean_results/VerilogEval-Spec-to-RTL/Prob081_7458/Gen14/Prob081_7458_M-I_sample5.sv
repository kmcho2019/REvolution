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

    // Intermediate AND gate outputs
    wire and_p1_group1 = p1a & p1b & p1c;
    wire and_p1_group2 = p1d & p1e & p1f;
    wire and_p2_group1 = p2a & p2b;
    wire and_p2_group2 = p2c & p2d;

    // OR gates for final outputs
    assign p1y = and_p1_group1 | and_p1_group2;
    assign p2y = and_p2_group1 | and_p2_group2;

endmodule