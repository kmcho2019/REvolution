module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Named intermediate AND outputs
    wire p1_abc = p1a & p1b & p1c;
    wire p1_def = p1d & p1e & p1f;
    wire p2_ab = p2a & p2b;
    wire p2_cd = p2c & p2d;

    // Direct assignments for OR outputs
    assign p1y = p1_abc | p1_def;
    assign p2y = p2_ab | p2_cd;

endmodule