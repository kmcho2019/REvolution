module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

assign next_state[0] = (~in & state[0]) | (~in & state[2]); // Next state is A when in=0 and current state is A or C
assign next_state[1] = (in & state[0]) | (in & state[3]) | (~in & state[1]); // Next state is B when in=1 and current state is A or D, or in=0 and current state is B
assign next_state[2] = (~in & state[1]) | (in & state[3]); // Next state is C when in=0 and current state is B, or in=1 and current state is D
assign next_state[3] = (in & state[2]); // Next state is D when in=1 and current state is C

assign out = state[3]; // Output is 1 when current state is D, 0 otherwise

endmodule