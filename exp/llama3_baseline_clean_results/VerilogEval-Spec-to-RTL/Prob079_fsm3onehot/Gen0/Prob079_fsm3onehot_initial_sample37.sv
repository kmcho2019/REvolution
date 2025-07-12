module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // state_D

// Next state logic
assign next_state[0] = (state[0] & ~in) | (state[2] & ~in) | (state[3] & ~in); // next_state_A
assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & in); // next_state_B
assign next_state[2] = (state[1] & ~in); // next_state_C
assign next_state[3] = (state[2] & in); // next_state_D

endmodule