module TopModule(
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

    // Intermediate wires for each AND gate output, reflecting 7458 structure
    wire and_p1_upper; // AND of p1a, p1b, p1c
    wire and_p1_lower; // AND of p1d, p1e, p1f
    wire and_p2_left;  // AND of p2a, p2b
    wire and_p2_right; // AND of p2c, p2d

    // 3-input AND gates for p1y
    assign and_p1_upper = p1a & p1b & p1c;
    assign and_p1_lower = p1d & p1e & p1f;

    // 2-input AND gates for p2y
    assign and_p2_left  = p2a & p2b;
    assign and_p2_right = p2c & p2d;

    // OR gates producing final outputs
    assign p1y = and_p1_upper | and_p1_lower;
    assign p2y = and_p2_left  | and_p2_right;

endmodule