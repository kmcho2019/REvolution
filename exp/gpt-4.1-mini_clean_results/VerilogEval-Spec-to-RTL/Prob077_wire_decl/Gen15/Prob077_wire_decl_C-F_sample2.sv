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

module InvGate (
    output y,
    input  x
);
    not (y, x);
endmodule

module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND outputs
    wire and_ab;
    wire and_cd;

    // First layer: AND gates
    AndGate and1 (.y(and_ab), .x1(a), .x2(b));
    AndGate and2 (.y(and_cd), .x1(c), .x2(d));

    // Second layer: OR gate
    OrGate or1 (.y(out), .x1(and_ab), .x2(and_cd));

    // Inverter for out_n
    InvGate inv1 (.y(out_n), .x(out));

endmodule