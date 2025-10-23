module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

or(out, (a & b), (c & d));
not(out_n, out);

endmodule