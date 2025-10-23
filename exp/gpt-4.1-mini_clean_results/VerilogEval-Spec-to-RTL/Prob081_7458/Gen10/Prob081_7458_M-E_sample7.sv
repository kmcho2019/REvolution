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

    // Four AND gates (corresponding to the 7458 chip's internal gates)
    wire and1_p1 = p1a & p1b & p1c; // first 3-input AND for p1y
    wire and2_p1 = p1d & p1e & p1f; // second 3-input AND for p1y

    wire and1_p2 = p2a & p2b;       // first 2-input AND for p2y
    wire and2_p2 = p2c & p2d;       // second 2-input AND for p2y

    // OR gates combining the AND gate outputs
    assign p1y = and1_p1 | and2_p1;
    assign p2y = and1_p2 | and2_p2;

endmodule