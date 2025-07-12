module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires to hold AND gate outputs
    wire and_ab;
    wire and_cd;

    // First layer: two AND gates with descriptive instance names
    and and_gate_ab (and_ab, a, b);
    and and_gate_cd (and_cd, c, d);

    // Second layer: OR gate combining the AND outputs
    or or_gate_out (out, and_ab, and_cd);

    // Inverted output of 'out'
    not not_gate_out_n (out_n, out);

endmodule