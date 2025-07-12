module AndGate (
    output y,
    input  x1,
    input  x2
);
    and (y, x1, x2);
endmodule

module OrGate (
    output y,
    input  x1,
    input  x2
);
    or (y, x1, x2);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate results
    wire and_ab;
    wire and_cd;

    // Instantiate two AND gates
    AndGate and_gate1 (.y(and_ab), .x1(a), .x2(b));
    AndGate and_gate2 (.y(and_cd), .x1(c), .x2(d));

    // Instantiate one OR gate
    OrGate or_gate (.y(out), .x1(and_ab), .x2(and_cd));

    // Continuous assignment for inverted output
    assign out_n = ~out;

endmodule