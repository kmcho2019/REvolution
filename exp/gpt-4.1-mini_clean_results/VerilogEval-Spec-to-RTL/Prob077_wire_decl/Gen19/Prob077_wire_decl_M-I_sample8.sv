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

    // Instantiate AND gates for the first layer using primitives
    and (and_ab, a, b);
    and (and_cd, c, d);

    // Instantiate OR gate for the second layer using primitive
    or (out, and_ab, and_cd);

    // Instantiate NOT gate for inverted output using primitive
    not (out_n, out);

endmodule