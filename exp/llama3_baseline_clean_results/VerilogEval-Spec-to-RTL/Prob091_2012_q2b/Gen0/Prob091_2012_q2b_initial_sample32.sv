module TopModule(
    input  [5:0] y,  // Current state
    input        w,  // Input to the FSM
    output       Y1, // Next state bit y[1]
    output       Y3  // Next state bit y[3]
);

// Direct implementation of next state logic for Y1 and Y3 based on one-hot encoding
assign Y1 = (y[5] && w) || (y[2] && ~w); // State E or C with w=1 for Y1 (next state B or D)
assign Y3 = (y[1] && w) || (y[4] && ~w) || (y[5] && ~w); // States B, E, or F with w=0 for Y3 (next state D)

endmodule