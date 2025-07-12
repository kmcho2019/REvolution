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
    // Intermediate wires connecting the outputs of AND gates to the OR gate
    wire and_out_ab;
    wire and_out_cd;

    // Instantiate AND gates for first layer
    AndGate and_gate_ab (.y(and_out_ab), .x1(a), .x2(b));
    AndGate and_gate_cd (.y(and_out_cd), .x1(c), .x2(d));

    // Instantiate OR gate for second layer to produce 'out'
    OrGate or_gate (.y(out), .x1(and_out_ab), .x2(and_out_cd));

    // Instantiate NOT gate primitive for inverted output 'out_n'
    not not_gate (out_n, out);

endmodule