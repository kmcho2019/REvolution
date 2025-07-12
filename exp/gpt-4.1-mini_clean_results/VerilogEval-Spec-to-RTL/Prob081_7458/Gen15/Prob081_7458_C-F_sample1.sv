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

    // Intermediate wires for 3-input AND gates (p1)
    wire p1_and1_out = p1a & p1b & p1c;
    wire p1_and2_out = p1d & p1e & p1f;

    // Intermediate wires for 2-input AND gates (p2)
    wire p2_and1_out = p2a & p2b;
    wire p2_and2_out = p2c & p2d;

    // Final OR outputs
    assign p1y = p1_and1_out | p1_and2_out;
    assign p2y = p2_and1_out | p2_and2_out;

endmodule