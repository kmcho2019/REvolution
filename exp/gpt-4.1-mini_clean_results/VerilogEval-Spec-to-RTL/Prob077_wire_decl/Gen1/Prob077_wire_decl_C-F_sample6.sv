module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_ab;
    wire and_cd;

    // First layer: two AND gates
    and u_and_ab (and_ab, a, b);
    and u_and_cd (and_cd, c, d);

    // Second layer: OR gate combining the AND outputs
    or  u_or_out (out, and_ab, and_cd);

    // Inverted output from 'out'
    not u_not_out_n (out_n, out);

endmodule