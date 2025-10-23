module TopModule(
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // First group of ANDs for p1y (3-input)
    wire p1_abc_and = p1a & p1b & p1c;
    wire p1_def_and = p1d & p1e & p1f;
    
    // Second group of ANDs for p2y (2-input)
    wire p2_ab_and = p2a & p2b;
    wire p2_cd_and = p2c & p2d;

    // Final OR outputs
    assign p1y = p1_abc_and | p1_def_and;
    assign p2y = p2_ab_and | p2_cd_and;

endmodule