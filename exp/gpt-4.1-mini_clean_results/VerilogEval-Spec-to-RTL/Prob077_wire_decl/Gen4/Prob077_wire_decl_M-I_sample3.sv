module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and0;

and (and0, a, b);
or  (out, and0, c, d);
not (out_n, out);

endmodule