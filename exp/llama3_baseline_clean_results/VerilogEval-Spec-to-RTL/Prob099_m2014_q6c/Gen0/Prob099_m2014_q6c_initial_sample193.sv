module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// We don't need Y1 and Y3 for the next state calculation
// We need to calculate Y2 and Y4
// For state B (y[1] = 1)
// The next state can be either C or D
// To be in state C, we need to be in state B and w = 0
// To be in state D, we need to be in state B and w = 1
// For state D (y[3] = 1)
// The next state can be either F or A
// To be in state F, we need to be in state D and w = 0
// To be in state A, we need to be in state D and w = 1

// Calculate Y2 (next state for y[1])
assign Y2 = (y[5] && w) || (y[4] && ~w) || (y[1] && w);

// Calculate Y4 (next state for y[3])
assign Y4 = (y[1] && ~w) || (y[3] && w) || (y[2] && w);

// No need to assign Y1 and Y3 in this case
endmodule