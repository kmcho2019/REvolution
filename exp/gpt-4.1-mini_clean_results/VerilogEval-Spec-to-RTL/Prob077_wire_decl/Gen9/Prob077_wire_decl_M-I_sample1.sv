module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

and U_and1 (and_ab, a, b);
and U_and2 (and_cd, c, d);

or  U_or1  (out, and_ab, and_cd);

not U_not1 (out_n, out);

endmodule