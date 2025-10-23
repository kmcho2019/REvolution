module TopModule(
    input [5:0] y,  // State vector (one-hot encoding)
    input w,       // Input to control state transitions
    output Y1,     // Next state signal for y[1] (state B)
    output Y3      // Next state signal for y[3] (state D)
);

// Deriving next-state logic for Y1 (state B) based on the state machine transitions
assign Y1 = (y[0] && w) || (y[1] && ~w);  // Transition to B (y[1]) from A or stay in B if w='1'

// Deriving next-state logic for Y3 (state D) based on the state machine transitions
assign Y3 = (y[2] && w) || (y[4] && w) || (y[3] && w);  // Transition to D (y[3]) from C, E, or stay in D if w='1'

endmodule