module MUX2to1(
    input  sel,
    input  in0,
    input  in1,
    output out
);

assign out = sel? in1 : in0;

endmodule

module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire or_bc;
assign or_bc = b || c;

MUX2to1 mux(
   .sel(a),
   .in0(or_bc),
   .in1(c),
   .out(q)
);

endmodule