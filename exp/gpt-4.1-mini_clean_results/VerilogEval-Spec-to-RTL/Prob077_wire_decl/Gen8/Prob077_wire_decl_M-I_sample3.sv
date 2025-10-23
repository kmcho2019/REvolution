module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_ab, and_cd;

and and1 (and_ab, a, b);
and and2 (and_cd, c, d);

or  or1  (out, and_ab, and_cd);

assign out_n = ~out;

endmodule