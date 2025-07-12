module TopModule (
    input p1a, p1b, p1c, p1d, p1e, p1f,
    input p2a, p2b, p2c, p2d,
    output p1y, p2y
);
    // Intermediate wires for AND gate outputs
    wire and1_out = p1a & p1b & p1c;
    wire and2_out = p1d & p1e & p1f;
    wire and3_out = p2a & p2b;
    wire and4_out = p2c & p2d;

    // Final OR outputs
    assign p1y = and1_out | and2_out;
    assign p2y = and3_out | and4_out;
endmodule