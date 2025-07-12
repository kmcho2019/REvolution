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

    // Instantiate AND gate primitives
    and U1 (and_ab, a, b);
    and U2 (and_cd, c, d);

    // Instantiate OR gate primitive
    or  U3 (out, and_ab, and_cd);

    // Instantiate NOT gate primitive for inverted output
    not U4 (out_n, out);

endmodule