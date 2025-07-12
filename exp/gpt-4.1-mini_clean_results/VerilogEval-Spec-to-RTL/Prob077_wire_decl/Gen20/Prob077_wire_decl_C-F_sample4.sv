module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires connecting the outputs of the AND gates
    wire and_ab;
    wire and_cd;

    // First layer: two AND gates (built-in gate primitives)
    and and1 (and_ab, a, b);
    and and2 (and_cd, c, d);

    // Second layer: OR gate (built-in gate primitive) combining AND outputs
    or or1 (out, and_ab, and_cd);

    // Inverter producing out_n from out (built-in gate primitive)
    not not1 (out_n, out);

endmodule