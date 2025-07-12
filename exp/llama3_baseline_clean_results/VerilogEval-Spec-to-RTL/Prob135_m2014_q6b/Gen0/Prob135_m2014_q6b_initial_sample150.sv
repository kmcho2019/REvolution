module TopModule(
    input [2:0] y,
    input w,
    output Y1
);

// Next-state logic for y[1]
wire next_y1;
assign next_y1 = (y == 3'b000 && w) || (y == 3'b001 && w) || (y == 3'b010 && w) || (y == 3'b011 && ~w) || (y == 3'b100 && ~w) || (y == 3'b101 && w);

// Current state y[1] output
assign Y1 = y[1];

endmodule