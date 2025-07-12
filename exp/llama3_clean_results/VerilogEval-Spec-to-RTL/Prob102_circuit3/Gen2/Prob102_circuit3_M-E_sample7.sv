module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab;
wire cd;

assign ab = a || b;
assign cd = c || d;
assign q = ab && cd;

endmodule