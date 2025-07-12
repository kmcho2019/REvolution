module TopModule (
    input  p1a,
    input  p1b,
    input  p1c,
    input  p1d,
    input  p1e,
    input  p1f,
    input  p2a,
    input  p2b,
    input  p2c,
    input  p2d,
    output p1y,
    output p2y
);

    // Intermediate wires for the AND gates
    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Four AND gates for the inputs, using built-in and primitive gates
    and and_gate1 (and1_p1, p1a, p1b, p1c);
    and and_gate2 (and2_p1, p1d, p1e, p1f);

    and and_gate3 (and1_p2, p2a, p2b);
    and and_gate4 (and2_p2, p2c, p2d);

    // Two OR gates combining the AND gate outputs for final outputs
    or  or_gate1  (p1y, and1_p1, and2_p1);
    or  or_gate2  (p2y, and1_p2, and2_p2);

endmodule