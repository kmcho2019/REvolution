module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// State transition logic
// Next state when in = 0
assign next_state[0] = (state[0] && ~in) | (state[2] && ~in);  // A or C -> A
assign next_state[1] = (state[1] && ~in) | (state[3] && ~in);  // B or D -> B
assign next_state[2] = state[1] && ~in;  // B -> C
assign next_state[3] = state[2] && ~in;  // C -> A (but we already handled this in next_state[0])

// Next state when in = 1
// Since next_state is 4 bits, and we are using one-hot encoding, 
// we need to make sure that the next state bits are mutually exclusive.
assign next_state[0] = next_state[0] || (state[0] && in);  // A -> B
assign next_state[1] = next_state[1] || (state[0] && in) || (state[1] && in);  // A or B -> B
assign next_state[2] = next_state[2] || (state[3] && in);  // D -> C
assign next_state[3] = next_state[3] || (state[2] && in);  // C -> D

// Output logic
assign out = state[3];  // Output is 1 only in state D

endmodule