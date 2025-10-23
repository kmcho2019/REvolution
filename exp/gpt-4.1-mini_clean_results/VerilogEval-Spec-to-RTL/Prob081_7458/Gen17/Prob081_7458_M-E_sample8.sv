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

    // Internal wires for the AND gates
    wire and1_p1, and2_p1;
    wire and1_p2, and2_p2;

    // Four AND gates explicitly instantiated
    and and_gate1_p1(and1_p1, p1a, p1b, p1c);   // 3-input AND #1 for p1y
    and and_gate2_p1(and2_p1, p1d, p1e, p1f);   // 3-input AND #2 for p1y

    and and_gate1_p2(and1_p2, p2a, p2b);         // 2-input AND #1 for p2y
    and and_gate2_p2(and2_p2, p2c, p2d);         // 2-input AND #2 for p2y

    // Two OR gates combining AND gate outputs
    or  or_gate_p1(p1y, and1_p1, and2_p1);
    or  or_gate_p2(p2y, and1_p2, and2_p2);

endmodule