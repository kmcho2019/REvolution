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

    // Instantiate two AND gates for the first layer using built-in primitives
    and(and_ab, a, b);
    and(and_cd, c, d);

    // Instantiate OR gate for the second layer using built-in primitive
    or(out, and_ab, and_cd);

    // Inverted output generated via continuous assignment for efficiency
    assign out_n = ~out;

endmodule