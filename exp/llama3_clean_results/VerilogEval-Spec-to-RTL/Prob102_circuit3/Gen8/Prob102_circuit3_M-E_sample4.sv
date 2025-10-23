module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ad;
assign ad = a && d;

wire bc_or_bd;
assign bc_or_bd = b && (c || d);

assign q = ad || bc_or_bd;

endmodule