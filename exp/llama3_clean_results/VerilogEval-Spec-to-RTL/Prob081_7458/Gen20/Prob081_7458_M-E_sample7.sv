module TopModule(
    input p1a,
    input p1b,
    input p1c,
    input p1d,
    input p1e,
    input p1f,
    input p2a,
    input p2b,
    input p2c,
    input p2d,
    output p1y,
    output p2y
);

    // Compute intermediate AND results
    wire and1 = p1a & p1b & p1c;
    wire and2 = p1d & p1e & p1f;
    wire and3 = p2a & p2b;
    wire and4 = p2c & p2d;

    // Compute final outputs using intermediate results
    assign p1y = and1 | and2;
    assign p2y = and3 | and4;

endmodule