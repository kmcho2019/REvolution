module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for the outputs of AND gates
    wire and_ab;
    wire and_cd;

    // First layer: AND gates implemented with built-in gate primitives
    and and1 (and_ab, a, b);
    and and2 (and_cd, c, d);

    // Second layer: OR gate combining AND outputs
    or or1 (out, and_ab, and_cd);

    // Inverter generating out_n from out
    not not1 (out_n, out);

endmodule