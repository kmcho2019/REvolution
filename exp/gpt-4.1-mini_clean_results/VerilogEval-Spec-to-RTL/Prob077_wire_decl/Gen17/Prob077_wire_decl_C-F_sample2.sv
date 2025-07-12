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
    // Intermediate wires for AND gate outputs
    wire and_ab;
    wire and_cd;

    // Instantiate two AND gates for first layer
    AndGate and1 (.y(and_ab), .x1(a), .x2(b));
    AndGate and2 (.y(and_cd), .x1(c), .x2(d));

    // Instantiate OR gate for second layer
    OrGate or1 (.y(out), .x1(and_ab), .x2(and_cd));

    // Inverted output via continuous assignment
    assign out_n = ~out;

endmodule