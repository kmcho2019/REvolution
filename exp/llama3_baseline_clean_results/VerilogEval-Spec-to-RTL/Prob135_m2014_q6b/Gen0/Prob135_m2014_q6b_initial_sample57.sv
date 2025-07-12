module TopModule(
    input [2:0] y,  // Current state
    input w,        // Input
    output Y1       // Output, which is y[1]
);

// The next-state logic for y[1]
wire next_y1;
assign next_y1 = (y == 3'b011 && w) || (y == 3'b111 && ~w);

// Assign Y1 as y[1]
assign Y1 = y[1];

endmodule