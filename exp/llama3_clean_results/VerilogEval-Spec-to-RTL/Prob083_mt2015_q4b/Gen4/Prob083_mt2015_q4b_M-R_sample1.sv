module TopModule(
    input x,
    input y,
    output z
);

// Intermediate wires for negations
wire not_x;
wire not_y;

// Assign negations
assign not_x = ~x;
assign not_y = ~y;

// Intermediate wires for AND operations
wire x_and_y;
wire not_x_and_not_y;

// Assign AND operations
assign x_and_y = x & y;
assign not_x_and_not_y = not_x & not_y;

// Final output
assign z = x_and_y | not_x_and_not_y;

endmodule