module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    // Intermediate wires for outputs of AND gates
    wire and_ab;
    wire and_cd;

    // First layer: two AND gates using gate primitives
    and (and_ab, a, b);
    and (and_cd, c, d);

    // Second layer: OR gate combining AND outputs
    or (out, and_ab, and_cd);

    // Inverted output generated via continuous assignment
    assign out_n = ~out;

endmodule