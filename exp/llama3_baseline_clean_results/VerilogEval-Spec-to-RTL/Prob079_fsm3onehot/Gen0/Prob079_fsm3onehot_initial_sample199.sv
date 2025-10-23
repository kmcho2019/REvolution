module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // Since only state D produces output 1

// State transition logic
assign next_state[0] = (state[0] & ~in) | (state[2] & ~in) | (state[1] & in); // Next state is A
assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & ~in); // Next state is B
assign next_state[2] = (state[1] & ~in) | (state[3] & in); // Next state is C
assign next_state[3] = state[2] & in; // Next state is D

endmodule