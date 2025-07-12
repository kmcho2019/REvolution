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

    // Intermediate wires for the AND gates' outputs
    wire and_p1_abc;
    wire and_p1_def;
    wire and_p2_ab;
    wire and_p2_cd;

    // 3-input AND gates for p1y
    assign and_p1_abc = p1a & p1b & p1c;
    assign and_p1_def = p1d & p1e & p1f;

    // 2-input AND gates for p2y
    assign and_p2_ab  = p2a & p2b;
    assign and_p2_cd  = p2c & p2d;

    // OR the outputs of the AND gates for final outputs
    assign p1y = and_p1_abc | and_p1_def;
    assign p2y = and_p2_ab  | and_p2_cd;

endmodule