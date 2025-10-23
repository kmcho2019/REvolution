module TopModule(
    input  in,
    input  [3:0] state,
    output [3:0] next_state,
    output out
);

// Deriving next state logic for each bit of next_state
// Since we're using one-hot encoding, each bit of next_state corresponds to a specific state (A, B, C, D)
// We use the state transition table to determine the next state for each current state and input

// Next state logic for A (4'b0001)
assign next_state[0] = (~in & state[0]) | (~in & state[2]); // Next state is A if current state is A and in=0, or if current state is C and in=0

// Next state logic for B (4'b0010)
assign next_state[1] = (in & state[0]) | (~in & state[1]) | (in & state[3]) | (~in & state[1]); // Next state is B if current state is A and in=1, or if current state is B (regardless of in), or if current state is D and in=1

// Next state logic for C (4'b0100)
assign next_state[2] = (~in & state[1]) | (~in & state[3]); // Next state is C if current state is B and in=0, or if current state is D and in=0

// Next state logic for D (4'b1000)
assign next_state[3] = (in & state[2]); // Next state is D if current state is C and in=1

// Output logic
assign out = state[3]; // Output is 1 if current state is D, otherwise it's 0

endmodule