module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y2,
    output Y3,
    output Y4
);

// Directly assign logic equations to outputs based on state machine transitions
assign Y1 = (y[3] & ~w); // Transition to state A
assign Y2 = (y[0] & w); // Transition to state B
assign Y3 = (y[1] & ~w) | (y[5] & ~w); // Transition to state C
assign Y4 = (y[1] & ~w) | (y[2] & w) | (y[4] & ~w) | (y[5] & w); // Transition to state D

endmodule