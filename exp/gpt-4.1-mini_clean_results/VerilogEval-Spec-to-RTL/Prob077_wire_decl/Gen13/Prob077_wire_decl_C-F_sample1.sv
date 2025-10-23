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
    // Intermediate wires for the two AND gates
    wire and_ab;
    wire and_cd;

    // Continuous assignments for AND gates to simplify and reduce hierarchy
    assign and_ab = a & b;
    assign and_cd = c & d;

    // Continuous assignment for OR gate output 'out'
    assign out = and_ab | and_cd;

    // Instantiate NOT gate module for inverted output, driven by 'out'
    NotGate inv (.y(out_n), .x(out));

endmodule