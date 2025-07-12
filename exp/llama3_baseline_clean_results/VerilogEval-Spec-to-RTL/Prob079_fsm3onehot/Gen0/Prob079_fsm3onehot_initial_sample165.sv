module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Deriving next state logic based on the given state transition table
// Next state logic for state A (4'b0001)
assign next_state[0] = (state[0] && !in) || (state[1] && !in) || (state[2] && !in);
// Next state logic for state B (4'b0010)
assign next_state[1] = (state[0] && in) || (state[1] && in) || (state[3] && !in);
// Next state logic for state C (4'b0100)
assign next_state[2] = (state[1] && !in) || (state[2] && in);
// Next state logic for state D (4'b1000)
assign next_state[3] = (state[2] && !in) || (state[3] && in);

// Output logic based on the current state
assign out = state[3]; // Output is 1 only in state D

endmodule