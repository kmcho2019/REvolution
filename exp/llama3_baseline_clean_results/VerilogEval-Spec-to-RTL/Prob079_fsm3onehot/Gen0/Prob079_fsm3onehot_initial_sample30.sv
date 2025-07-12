module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic
assign out = (state[3]); // D state has output 1, all other states have output 0

// Next state logic
assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[1]); // A state
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // B state
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C state
assign next_state[3] = (in & state[2]); // D state

endmodule