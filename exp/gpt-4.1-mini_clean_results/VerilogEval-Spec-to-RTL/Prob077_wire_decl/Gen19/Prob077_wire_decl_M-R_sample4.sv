module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND results
    wire and_ab;
    wire and_cd;

    // First layer: AND gates as gate primitives
    and and1 (and_ab, a, b);
    and and2 (and_cd, c, d);

    // Second layer: OR gate as primitive
    or or1 (out, and_ab, and_cd);

    // Inverted output as NOT primitive
    not not1 (out_n, out);

endmodule