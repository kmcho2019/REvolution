module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire or_ab;
wire or_cd;

assign or_ab = a | b;
assign or_cd = c | d;

assign q = or_ab ? or_cd : 1'b0;

endmodule