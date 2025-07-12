module TopModule(
    input [3:0] x,
    output f
);

wire condition1;
wire condition2;
wire condition3;

assign condition1 = x[3] & x[0];
assign condition2 = ~x[3] & x[0] & x[1] & x[2];
assign condition3 = x[3] & x[1] & x[2];

assign f = condition1 | condition2 | condition3;

endmodule