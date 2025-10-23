module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Derive next state logic based on the given state machine table
assign next_state[0] = (state[0] & ~in) | (state[3] & in); // State A
assign next_state[1] = (state[1] & (~in | in)) | (state[0] & in); // State B
assign next_state[2] = (state[1] & ~in) | (state[2] & in) | (state[3] & ~in); // State C
assign next_state[3] = (state[2] & in); // State D

// Derive output logic
assign out = state[3]; // Output is 1 when in state D

endmodule