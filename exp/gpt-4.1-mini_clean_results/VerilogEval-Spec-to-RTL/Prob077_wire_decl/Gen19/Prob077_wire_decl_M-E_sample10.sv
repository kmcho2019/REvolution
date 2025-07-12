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
    // Intermediate wires for AND gate outputs using continuous assignment
    wire and_ab = a & b;
    wire and_cd = c & d;

    // Instantiate OR gate for the second layer
    OrGate or1 (.y(out), .x1(and_ab), .x2(and_cd));

    // Instantiate NOT gate to generate inverted output from 'out'
    NotGate not1 (.y(out_n), .x(out));

endmodule