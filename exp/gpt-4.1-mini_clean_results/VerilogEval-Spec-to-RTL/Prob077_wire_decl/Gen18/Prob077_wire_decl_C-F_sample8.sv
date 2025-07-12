module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate results
    wire and_ab;
    wire and_cd;

    // Explicit gate primitives instantiation
    and (and_ab, a, b);
    and (and_cd, c, d);

    or  (out, and_ab, and_cd);

    // Continuous assignment for inverted output to reduce module overhead
    assign out_n = ~out;

endmodule