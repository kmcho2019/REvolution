module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// next state logic
assign next_state[0] = (~in & (state[0] | state[2])) | (in & state[0]); // next state A
assign next_state[1] = (in & (state[0] | state[1] | state[3])) | (~in & state[1]); // next state B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // next state C
assign next_state[3] = (in & state[2]) | (~in & state[0] & ~state[1] & ~state[2] & ~state[3]); // next state D, however since we are one-hot encoded, when state is A, it is state[0] & ~state[1] & ~state[2] & ~state[3]

// output logic
assign out = state[3]; // output is 1 when current state is D

endmodule