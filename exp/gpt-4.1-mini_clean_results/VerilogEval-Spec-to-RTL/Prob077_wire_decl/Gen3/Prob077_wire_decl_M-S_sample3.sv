module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and0, and1;

and (and0, a, b);
and (and1, c, d);
or  (out, and0, and1);
not (out_n, out);

endmodule