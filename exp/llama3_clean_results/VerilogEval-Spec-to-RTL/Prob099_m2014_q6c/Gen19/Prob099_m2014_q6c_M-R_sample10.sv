module TopModule(
    input [5:0] y,  // One-hot encoded state
    input w,       // Input signal
    output Y1,     // Next-state signal for state B
    output Y3      // Next-state signal for state D
);

// Directly implement next-state logic based on the state machine transitions
assign Y1 = (y[5] && ~w) || (y[0] && ~w);  // Transition to state B
assign Y3 = (y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w);  // Transition to state D

endmodule