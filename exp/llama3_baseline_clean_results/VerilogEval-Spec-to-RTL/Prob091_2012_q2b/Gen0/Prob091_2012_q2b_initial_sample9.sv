module TopModule(
    input  [5:0] y,  // Current state
    input  w,       // Input to the state machine
    output Y1,      // Next state bit y[1]
    output Y3       // Next state bit y[3]
);

// Implementing the logic for Y1 (next state bit y[1])
// Y1 is 1 when the next state will be B or E
assign Y1 = (y[0] && w) || (y[2] && w) || (y[4] && w);

// Implementing the logic for Y3 (next state bit y[3])
// Y3 is 1 when the next state will be D
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && ~w) || (y[3] && ~w) || (y[5] && ~w);

endmodule