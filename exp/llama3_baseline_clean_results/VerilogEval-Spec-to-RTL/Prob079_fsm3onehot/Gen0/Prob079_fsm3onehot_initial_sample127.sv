module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state[0] = (state[0] & ~in) | (state[2] & ~in); // Next state is A when current state is A or C and in is 0
assign next_state[1] = (state[0] & in) | (state[1] & in) | (state[3] & ~in); // Next state is B when current state is A or B and in is 1, or current state is D and in is 0
assign next_state[2] = (state[1] & ~in); // Next state is C when current state is B and in is 0
assign next_state[3] = (state[2] & in); // Next state is D when current state is C and in is 1

// Output logic
assign out = state[3]; // Output is 1 when current state is D

endmodule