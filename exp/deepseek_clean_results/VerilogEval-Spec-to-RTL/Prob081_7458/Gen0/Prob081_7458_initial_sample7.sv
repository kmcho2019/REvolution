module TopModule(
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y
    wire and3_out, and4_out;  // For p2y

    // First OR gate inputs (3-input ANDs)
    assign and1_out = p1a & p1b & p1c;
    assign and2_out = p1d & p1e & p1f;

    // Second OR gate inputs (2-input ANDs)
    assign and3_out = p2a & p2b;
    assign and4_out = p2c & p2d;

    // Output OR gates
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;

endmodule