module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Directly assign logic equations to outputs based on state machine transitions
assign Y1 = (y[3] & ~w); // Transition to state A
assign Y3 = (y[1] & ~w) | (y[5] & ~w); // Transition to state C

endmodule