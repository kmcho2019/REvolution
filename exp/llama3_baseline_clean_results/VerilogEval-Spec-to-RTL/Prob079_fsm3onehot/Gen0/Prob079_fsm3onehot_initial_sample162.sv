module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic (one-hot encoding)
// out should be 1 only when the state is D
assign out = state[3];

// State transition logic
// For each state, determine the next state based on the input
assign next_state[0] = (state[0] && !in) || (state[2] && !in) || (state[1] && in); // Next state A
assign next_state[1] = (state[0] && in) || (state[1] && in) || (state[3] && in); // Next state B
assign next_state[2] = (state[1] && !in) || (state[3] && !in); // Next state C
assign next_state[3] = state[2] && in; // Next state D

endmodule