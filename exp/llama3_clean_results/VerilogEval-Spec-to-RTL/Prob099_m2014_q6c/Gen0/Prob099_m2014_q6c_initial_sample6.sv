module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Next-state signal Y2 (state B)
// State A transitions to state B when w is 1
// State B transitions to state D when w is 1
// State E transitions to state D when w is 1
// State F transitions to state C when w is 0, and to state D when w is 1
assign Y2 = (y[0] && w) || (y[4] && ~w) || (y[5] && w);

// Next-state signal Y4 (state D)
// State B transitions to state D when w is 1
// State C transitions to state D when w is 1
// State E transitions to state D when w is 1
// State D transitions to state A when w is 0, and stays in state D when w is 1, but also transitions to state F when w is 0
assign Y4 = (y[1] && w) || (y[2] && w) || (y[4] && w);

// Output signals
assign Y1 = y[0];
assign Y3 = y[2];

endmodule