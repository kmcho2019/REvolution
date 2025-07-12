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

    // Individual AND gate outputs for p1y
    wire p1_and_abc = p1a & p1b & p1c;
    wire p1_and_def = p1d & p1e & p1f;

    // Individual AND gate outputs for p2y
    wire p2_and_ab = p2a & p2b;
    wire p2_and_cd = p2c & p2d;

    // OR outputs formed by ORing corresponding AND gates
    assign p1y = p1_and_abc | p1_and_def;
    assign p2y = p2_and_ab  | p2_and_cd;

endmodule