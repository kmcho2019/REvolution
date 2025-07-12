module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Next state logic
assign next_state[0] = (~in & state[0]) | (~in & state[1] & ~state[2] & ~state[3]) | (in & state[2]) | (~in & state[3] & ~state[1] & ~state[2]);
assign next_state[1] = (in & state[0]) | (state[1] & ~in & ~state[2] & ~state[3]) | (in & state[1]) | (in & state[3] & ~state[0] & ~state[2]);
assign next_state[2] = (~in & ~state[0] & state[1] & ~state[3]) | (in & state[3] & ~state[0] & ~state[1]);
assign next_state[3] = (in & state[2]);

// Output logic
assign out = state[3];

endmodule