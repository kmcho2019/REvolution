module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and_ab;
    wire and_cd;

    // First layer: AND gates instantiated as primitives
    and (and_ab, a, b);
    and (and_cd, c, d);

    // Second layer: OR gate instantiated as primitive
    or  (out, and_ab, and_cd);

    // Inverted output via continuous assignment
    assign out_n = ~out;

endmodule