module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting gate outputs
    wire and_ab;
    wire and_cd;

    // First layer: AND gates
    and (and_ab, a, b);
    and (and_cd, c, d);

    // Second layer: OR gate
    or  (out, and_ab, and_cd);

    // Inverted output
    not (out_n, out);

endmodule