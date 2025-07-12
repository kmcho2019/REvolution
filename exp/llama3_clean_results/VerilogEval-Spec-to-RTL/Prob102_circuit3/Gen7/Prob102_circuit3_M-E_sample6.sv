module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_or;
assign ab_or = a | b;

wire cd_or;
assign cd_or = c | d;

assign q = ab_or & cd_or;

endmodule