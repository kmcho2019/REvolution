module TopModule(
    input x3,
    input x2,
    input x1,
    output f
);

wire x2_not_x3; // Intermediate wire for (x2 & ~x3)
wire x1_and_x3; // Intermediate wire for (x1 & x3)
wire x1_and_x2; // Intermediate wire for (x1 & x2)

assign x2_not_x3 = x2 & ~x3;
assign x1_and_x3 = x1 & x3;
assign x1_and_x2 = x1 & x2;

assign f = x2_not_x3 | x1_and_x3 | x1_and_x2;

endmodule