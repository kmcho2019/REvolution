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

    // Intermediate wires representing the four AND gates of the 7458 chip
    wire and_p1_upper  = p1a & p1b & p1c;
    wire and_p1_lower  = p1d & p1e & p1f;
    wire and_p2_left   = p2a & p2b;
    wire and_p2_right  = p2c & p2d;

    // Final outputs as OR of the respective AND gate outputs
    assign p1y = and_p1_upper | and_p1_lower;
    assign p2y = and_p2_left  | and_p2_right;

endmodule