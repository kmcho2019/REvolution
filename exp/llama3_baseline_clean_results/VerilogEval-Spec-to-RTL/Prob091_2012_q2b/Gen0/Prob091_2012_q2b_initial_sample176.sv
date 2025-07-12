module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// State A (000001)
// State B (000010)
// State C (000100)
// State D (001000)
// State E (010000)
// State F (100000)

assign Y1 = (y[0] & ~w) | (y[1] & ~w) | (y[4] & w); // Transition to state B
assign Y3 = (~y[0] & y[1] & ~w) | (y[2] & ~w) | (y[4] & ~w) | (y[5] & ~w); // Transition to state D

endmodule