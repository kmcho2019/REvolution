module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and_out_ab;
    wire and_out_cd;

    // First layer: two AND gates
    and and_gate_ab (and_out_ab, a, b);
    and and_gate_cd (and_out_cd, c, d);

    // Second layer: OR gate combining the AND gate outputs
    or or_gate_out (out, and_out_ab, and_out_cd);

    // Inverted output using NOT primitive on 'out'
    not not_gate_out_n (out_n, out);

endmodule