module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires from the AND gates
    wire and_ab;
    wire and_cd;

    // First layer: two AND gates
    and and_gate_ab (and_ab, a, b);
    and and_gate_cd (and_cd, c, d);

    // Second layer: OR gate combining the outputs of AND gates
    or or_gate_out (out, and_ab, and_cd);

    // Inverted output using NOT gate primitive
    not not_gate_out_n (out_n, out);

endmodule