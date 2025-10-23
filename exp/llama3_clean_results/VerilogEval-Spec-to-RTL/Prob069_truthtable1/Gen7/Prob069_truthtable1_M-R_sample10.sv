module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

wire cond1;
wire cond2;

assign cond1 = x2 & ~x3;
assign cond2 = x1 & x3;
assign f = cond1 | cond2;

endmodule