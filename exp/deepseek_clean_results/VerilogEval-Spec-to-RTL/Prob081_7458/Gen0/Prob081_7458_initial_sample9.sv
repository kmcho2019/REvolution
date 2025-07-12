module TopModule (
    input  p1a, p1b, p1c, p1d, p1e, p1f,
    input  p2a, p2b, p2c, p2d,
    output p1y, p2y
);

    // Intermediate wires for AND gate outputs
    wire and1_out, and2_out;  // For p1y's AND gates
    wire and3_out, and4_out;  // For p2y's AND gates

    // First OR gate inputs (p1y): AND of p1a, p1b, p1c and AND of p1d, p1e, p1f
    assign and1_out = p1a & p1b & p1c;
    assign and2_out = p1d & p1e & p1f;
    assign p1y = and1_out | and2_out;

    // Second OR gate inputs (p2y): AND of p2a, p2b and AND of p2c, p2d
    assign and3_out = p2a & p2b;
    assign and4_out = p2c & p2d;
    assign p2y = and3_out | and4_out;

endmodule