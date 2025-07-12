module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

wire na = ~a;
wire nb = ~b;
wire nc = ~c;
wire nd = ~d;

wire or_ab = a | b;
wire nd_na = nd & na;
wire nc_part = nb | nd_na;
wire c_part  = nd_na | (d & or_ab);

assign out = (nc & nc_part) | (c & c_part);

endmodule