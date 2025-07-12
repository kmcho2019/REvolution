module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and1_out;
wire and2_out;

and and1(a, b, and1_out);
and and2(c, d, and2_out);
or  or1(and1_out, and2_out, out);
not not1(out, out_n);

endmodule