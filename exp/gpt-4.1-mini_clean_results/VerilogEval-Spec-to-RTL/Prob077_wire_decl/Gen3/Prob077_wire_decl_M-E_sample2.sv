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
    wire not_and_ab;
    wire not_and_cd;

    // First layer: two AND gates
    and u_and_ab(and_ab, a, b);
    and u_and_cd(and_cd, c, d);

    // Invert the outputs of the AND gates
    not u_not_and_ab(not_and_ab, and_ab);
    not u_not_and_cd(not_and_cd, and_cd);

    // OR gate implemented using NAND of the inverted AND outputs (De Morgan's)
    nand u_nand_or(out, not_and_ab, not_and_cd);

    // Inverted output of out
    not u_not_out(out_n, out);

endmodule