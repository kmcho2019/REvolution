module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire sel;
assign sel = a || b;

wire cd_or;
assign cd_or = c || d;

assign q = sel? cd_or : 0;

endmodule