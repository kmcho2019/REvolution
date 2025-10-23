module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y's AND gates
    wire and3_out, and4_out;  // For p2y's AND gates

    // First set of AND gates for p1y
    assign and1_out = p1a & p1b & p1c;
    assign and2_out = p1d & p1e & p1f;

    // Second set of AND gates for p2y
    assign and3_out = p2a & p2b;
    assign and4_out = p2c & p2d;

    // OR gates for final outputs
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;

endmodule