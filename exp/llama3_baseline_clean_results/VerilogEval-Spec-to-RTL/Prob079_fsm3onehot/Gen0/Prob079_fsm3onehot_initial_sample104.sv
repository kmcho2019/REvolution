module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = state[3]; // Output is 1 when current state is D (4'b1000)

// Next state logic
assign next_state[0] = (~in & (state[0] | state[2])) | (in & ~state[3] & ~state[2] & ~state[1]); // Next state is A (4'b0001) when current state is A and in is 0, or when current state is C and in is 0
assign next_state[1] = ((~in | in) & (state[1] | state[0] & in | state[3] & in)); // Next state is B (4'b0010) when current state is A and in is 1, or when current state is B and in is 1 or 0, or when current state is D and in is 1
assign next_state[2] = (~in & (state[1] | state[3])); // Next state is C (4'b0100) when current state is B and in is 0, or when current state is D and in is 0
assign next_state[3] = (in & state[2]); // Next state is D (4'b1000) when current state is C and in is 1

endmodule