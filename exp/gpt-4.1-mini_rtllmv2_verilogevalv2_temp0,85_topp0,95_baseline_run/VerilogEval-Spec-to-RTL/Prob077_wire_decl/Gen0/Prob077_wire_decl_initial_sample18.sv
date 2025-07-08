module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);
    wire and_ab;
    wire and_cd;

    and u_and1(and_ab, a, b);
    and u_and2(and_cd, c, d);

    or u_or(out, and_ab, and_cd);

    not u_not(out_n, out);

endmodule