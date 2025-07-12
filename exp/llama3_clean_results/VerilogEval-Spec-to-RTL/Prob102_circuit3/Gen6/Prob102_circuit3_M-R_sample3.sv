module TopModule(
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire b_cd;
wire a_cd;

assign b_cd = b && (c || d);
assign a_cd = a && (c || d);
assign q = b_cd || a_cd;

endmodule