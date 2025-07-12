module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire w1, w2;

and and_gate1 (w1, a, b);
and and_gate2 (w2, c, d);
or  or_gate   (out, w1, w2);
not not_gate  (out_n, out);

endmodule