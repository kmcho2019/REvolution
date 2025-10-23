module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire select;
assign select = ~(a & d);

module MUX2x1(
    input  sel,
    input  i0,
    input  i1,
    output out
);
assign out = sel? i1 : i0;
endmodule

MUX2x1 mux(
   .sel(select),
   .i0(b),
   .i1(c),
   .out(q)
);

endmodule