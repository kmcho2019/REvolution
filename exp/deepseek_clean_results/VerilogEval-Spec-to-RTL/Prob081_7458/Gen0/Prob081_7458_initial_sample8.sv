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

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y calculation
    wire and3_out, and4_out;  // For p2y calculation

    // First 3-input AND for p1y (p1a & p1b & p1c)
    assign and1_out = p1a & p1b & p1c;

    // Second 3-input AND for p1y (p1d & p1e & p1f)
    assign and2_out = p1d & p1e & p1f;

    // First 2-input AND for p2y (p2a & p2b)
    assign and3_out = p2a & p2b;

    // Second 2-input AND for p2y (p2c & p2d)
    assign and4_out = p2c & p2d;

    // Final OR outputs
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;

endmodule