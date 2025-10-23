module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output q
);

wire ab_nand;
wire cd_nand;

assign ab_nand = ~(a & b);
assign cd_nand = ~(c & d);
assign q = ~(ab_nand & cd_nand);

endmodule