module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y
    wire and3_out, and4_out;  // For p2y

    // First OR input (p1y): AND of p1a, p1b, p1c
    assign and1_out = p1a & p1b & p1c;
    // Second OR input (p1y): AND of p1d, p1e, p1f
    assign and2_out = p1d & p1e & p1f;
    // p1y output
    assign p1y = and1_out | and2_out;

    // First OR input (p2y): AND of p2a, p2b
    assign and3_out = p2a & p2b;
    // Second OR input (p2y): AND of p2c, p2d
    assign and4_out = p2c & p2d;
    // p2y output
    assign p2y = and3_out | and4_out;

endmodule