module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    // Intermediate wires for AND gate outputs
    wire and_ab, and_cd;

    // First layer: two AND gates
    and U_and1 (and_ab, a, b);
    and U_and2 (and_cd, c, d);

    // Second layer: OR gate combining AND outputs
    or U_or (out, and_ab, and_cd);

    // Inverted output: NOT gate on 'out'
    not U_not (out_n, out);

endmodule