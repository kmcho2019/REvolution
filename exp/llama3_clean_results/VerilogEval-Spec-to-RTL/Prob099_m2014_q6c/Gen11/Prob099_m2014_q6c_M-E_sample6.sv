module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Define the current states as one-hot encoded signals
wire stateA, stateB, stateC, stateD, stateE, stateF;
assign stateA = y[0];
assign stateB = y[1];
assign stateC = y[2];
assign stateD = y[3];
assign stateE = y[4];
assign stateF = y[5];

// Derive next-state logic for Y1 (corresponding to state A)
assign Y1 = (stateD & ~w); // Transition to state A from state D when w is 0

// Derive next-state logic for Y3 (corresponding to state C)
assign Y3 = (stateB & ~w) | (stateF & ~w); // Transition to state C from state B or F when w is 0

endmodule