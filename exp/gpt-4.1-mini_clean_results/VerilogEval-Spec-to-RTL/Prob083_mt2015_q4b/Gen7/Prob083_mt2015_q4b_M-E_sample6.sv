module TopModule (
    input x,
    input y,
    output z
);

wire x_and_y;
wire nx_and_ny;
wire nx;
wire ny;

assign nx = ~x;
assign ny = ~y;

assign x_and_y = x & y;
assign nx_and_ny = nx & ny;

assign z = x_and_y | nx_and_ny;

endmodule