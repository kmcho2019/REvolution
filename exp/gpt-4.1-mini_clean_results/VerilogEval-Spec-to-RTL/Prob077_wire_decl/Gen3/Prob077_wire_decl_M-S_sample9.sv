module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and0, and1;

and u1(and0, a, b);
and u2(and1, c, d);
or  u3(out, and0, and1);
not u4(out_n, out);

endmodule