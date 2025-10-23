module TopModule (
    input x,
    input y,
    output z
);

wire x_and_y;
wire not_x;
wire not_y;
wire not_x_and_not_y;

assign not_x = ~x;
assign not_y = ~y;

assign x_and_y = x & y;
assign not_x_and_not_y = not_x & not_y;

assign z = x_and_y | not_x_and_not_y;

endmodule