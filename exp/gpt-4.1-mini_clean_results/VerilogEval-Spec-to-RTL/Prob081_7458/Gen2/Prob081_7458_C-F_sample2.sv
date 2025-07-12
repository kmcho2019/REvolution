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

    // Intermediate signals for each AND gate
    wire and_p1_abc = p1a & p1b & p1c;
    wire and_p1_def = p1d & p1e & p1f;

    wire and_p2_ab = p2a & p2b;
    wire and_p2_cd = p2c & p2d;

    // Final outputs as OR of respective AND gates
    assign p1y = and_p1_abc | and_p1_def;
    assign p2y = and_p2_ab | and_p2_cd;

endmodule