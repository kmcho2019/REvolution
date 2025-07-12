module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate AND outputs
    wire p1_and1 = p1a & p1b & p1c;
    wire p1_and2 = p1d & p1e & p1f;
    wire p2_and1 = p2a & p2b;
    wire p2_and2 = p2c & p2d;

    // Final OR outputs
    assign p1y = p1_and1 | p1_and2;
    assign p2y = p2_and1 | p2_and2;
endmodule