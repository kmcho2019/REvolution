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

and and1(
   .a(a),
   .b(b),
   .out(and_out1)
);

and and2(
   .a(c),
   .b(d),
   .out(and_out2)
);

or or1(
   .a(and_out1),
   .b(and_out2),
   .out(out)
);

not not1(
   .a(out),
   .out(out_n)
);

endmodule