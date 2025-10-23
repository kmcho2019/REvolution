module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

    wire or_ab;
    wire or_cd;

    or u1 (or_ab, a, b);
    or u2 (or_cd, c, d);
    and u3 (q, or_ab, or_cd);

endmodule