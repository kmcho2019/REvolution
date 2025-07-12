module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires for the outputs of the AND gates
    wire and_ab;
    wire and_cd;

    // First layer: instantiate AND gate primitives
    and and_gate1 (and_ab, a, b);
    and and_gate2 (and_cd, c, d);

    // Second layer: OR gate primitive on the AND outputs
    or or_gate (out, and_ab, and_cd);

    // Inverted output via NOT gate primitive on 'out'
    not not_gate (out_n, out);

endmodule