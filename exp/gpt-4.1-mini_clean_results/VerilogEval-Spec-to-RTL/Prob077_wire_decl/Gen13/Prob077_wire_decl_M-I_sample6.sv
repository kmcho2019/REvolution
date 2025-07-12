module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for outputs of AND gates
    wire and_out_ab;
    wire and_out_cd;

    // First layer: AND gates
    and and_gate_ab (and_out_ab, a, b);
    and and_gate_cd (and_out_cd, c, d);

    // Second layer: OR gate
    or or_gate (out, and_out_ab, and_out_cd);

    // Inverted output using NOT gate primitive
    not not_gate (out_n, out);

endmodule