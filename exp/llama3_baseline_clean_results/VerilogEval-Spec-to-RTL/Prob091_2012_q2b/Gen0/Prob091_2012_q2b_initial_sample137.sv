module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive the next-state logic for y[1] and y[3] based on the current state and the input w
assign Y1 = (y[5] && w) || (y[1] && ~w); // y[1] is set when state F (y[5]) and w = 1, or when state B (y[1]) and w = 0
assign Y3 = (y[2] && w) || (y[3] && ~w) || (y[4] && ~w); // y[3] is set when state C (y[2]) and w = 1, or when state D (y[3]) and w = 0, or when state E (y[4]) and w = 0

endmodule