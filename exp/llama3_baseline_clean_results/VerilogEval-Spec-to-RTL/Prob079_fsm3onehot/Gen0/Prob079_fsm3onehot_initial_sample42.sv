module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Output logic: out is 1 if current state is D, 0 otherwise
assign out = state[3]; // state[3] corresponds to D in one-hot encoding

// Next state logic
// A (4'b0001) to A if in=0, to B if in=1
// B (4'b0010) to C if in=0, to B if in=1
// C (4'b0100) to A if in=0, to D if in=1
// D (4'b1000) to C if in=0, to B if in=1

// Break down next_state logic into components for each next state bit
// For next state A (bit 0):
assign next_state[0] = (state[0] && !in) || (state[2] && !in); // from A or C to A if in=0

// For next state B (bit 1):
assign next_state[1] = (state[0] && in) || (state[1] && in) || (state[3] && in); // from A, B, or D to B if in=1

// For next state C (bit 2):
assign next_state[2] = (state[1] && !in) || (state[3] && !in); // from B or D to C if in=0

// For next state D (bit 3):
assign next_state[3] = state[2] && in; // from C to D if in=1

endmodule