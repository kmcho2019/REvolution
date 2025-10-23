module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Next State Logic
// Since we're using one-hot encoding, we can directly use the bits of the state to determine the next state
assign next_state[0] = (~in & state[0]) | (~in & state[2]) | (in & state[1]); // A
assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]); // B
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // C
assign next_state[3] = (in & state[2]); // D

// Output Logic
assign out = state[3]; // Output is 1 only when the state is D

endmodule