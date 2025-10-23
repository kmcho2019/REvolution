module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // First level: AND operations
    wire p1_and_abc = p1a & p1b & p1c;
    wire p1_and_def = p1d & p1e & p1f;
    wire p2_and_ab = p2a & p2b;
    wire p2_and_cd = p2c & p2d;

    // Second level: OR operations
    assign p1y = p1_and_abc | p1_and_def;
    assign p2y = p2_and_ab | p2_and_cd;

endmodule