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

    // 3-input ANDs for p1y calculated directly with assign statements
    wire p1_and1_out = p1a & p1b & p1c;
    wire p1_and2_out = p1d & p1e & p1f;

    // 2-input ANDs for p2y calculated directly with assign statements
    wire p2_and1_out = p2a & p2b;
    wire p2_and2_out = p2c & p2d;

    // OR the AND outputs to produce final outputs
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;

endmodule