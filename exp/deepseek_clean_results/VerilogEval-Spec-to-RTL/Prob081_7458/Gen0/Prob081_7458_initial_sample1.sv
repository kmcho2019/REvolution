module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y
    wire and3_out, and4_out;  // For p2y

    // First 3-input AND gate (p1a, p1b, p1c)
    assign and1_out = p1a & p1b & p1c;

    // Second 3-input AND gate (p1d, p1e, p1f)
    assign and2_out = p1d & p1e & p1f;

    // First 2-input AND gate (p2a, p2b)
    assign and3_out = p2a & p2b;

    // Second 2-input AND gate (p2c, p2d)
    assign and4_out = p2c & p2d;

    // Output p1y is OR of the two 3-input AND outputs
    assign p1y = and1_out | and2_out;

    // Output p2y is OR of the two 2-input AND outputs
    assign p2y = and3_out | and4_out;

endmodule