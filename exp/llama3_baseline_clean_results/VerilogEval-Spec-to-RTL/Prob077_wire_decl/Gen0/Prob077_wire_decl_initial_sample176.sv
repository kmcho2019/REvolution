module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out,
    output out_n
);

wire and_out1;
wire and_out2;

and and1(and_out1, a, b);
and and2(and_out2, c, d);
or  or1(out, and_out1, and_out2);
not not1(out_n, out);

endmodule