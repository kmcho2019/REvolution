module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

    or  or1(out, a & b, c & d);
    not not1(out_n, out);

endmodule