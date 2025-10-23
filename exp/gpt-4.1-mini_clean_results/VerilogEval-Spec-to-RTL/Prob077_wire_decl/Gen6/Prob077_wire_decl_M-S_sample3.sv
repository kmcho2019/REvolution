module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

and U1 (and_ab, a, b);
and U2 (and_cd, c, d);
or  U3 (out, and_ab, and_cd);
not U4 (out_n, out);

endmodule