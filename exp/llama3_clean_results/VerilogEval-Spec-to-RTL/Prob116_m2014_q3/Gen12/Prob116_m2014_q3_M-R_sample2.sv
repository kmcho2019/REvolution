module TopModule(
    input [3:0] x,
    output f
);

wire x3_and_x1_or_x2;
wire x3_and_x1_and_x2;

assign x3_and_x1_or_x2 = x[3] && (x[1] || x[2]);
assign x3_and_x1_and_x2 = x[3] && x[1] && x[2];

assign f = x3_and_x1_or_x2 || x3_and_x1_and_x2;

endmodule