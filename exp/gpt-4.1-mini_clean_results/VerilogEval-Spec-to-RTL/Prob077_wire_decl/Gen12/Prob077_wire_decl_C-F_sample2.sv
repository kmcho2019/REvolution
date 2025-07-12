module OrGate (
    output y,
    input  x1,
    input  x2
);
    or (y, x1, x2);
endmodule

module NotGate (
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
    // Intermediate wires for AND results
    wire and_ab;
    wire and_cd;

    // First layer: continuous assignments for AND gates
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Second layer: OR gate instantiated structurally
    OrGate or1 (.y(out), .x1(and_ab), .x2(and_cd));

    // Inverted output instantiated structurally as a NOT gate
    NotGate not1 (.y(out_n), .x(out));

endmodule