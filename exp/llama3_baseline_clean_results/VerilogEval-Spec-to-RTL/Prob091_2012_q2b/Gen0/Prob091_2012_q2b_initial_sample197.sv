module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A is represented by y[0], State B by y[1], State C by y[2], 
// State D by y[3], State E by y[4], and State F by y[5]

// Y1 corresponds to the next state of y[1] (State B)
assign Y1 = (y[0] & ~w) | (y[1] & ~w); // Transition to B from A when w=0, or stay in B when w=0

// Y3 corresponds to the next state of y[3] (State D)
assign Y3 = (y[1] & ~w) | (y[2] & ~w) | (y[3] & ~w) | (y[4] & ~w) | (y[5] & ~w); 
// Transition to D from B, C, E, or F when w=0

endmodule