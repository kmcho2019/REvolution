module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Direct implementation based on one-hot encoding and state transitions
assign Y1 = (y[5:0] == 6'b000001 && w) || (y[5:0] == 6'b000010 && ~w); // Transition to B (y[1] = 1)
assign Y3 = (y[5:0] == 6'b000001 && ~w) || (y[5:0] == 6'b000100 && ~w) || (y[5:0] == 6'b001000) || (y[5:0] == 6'b010000 && ~w) || (y[5:0] == 6'b100000 && ~w); // Transition to D (y[3] = 1)

endmodule