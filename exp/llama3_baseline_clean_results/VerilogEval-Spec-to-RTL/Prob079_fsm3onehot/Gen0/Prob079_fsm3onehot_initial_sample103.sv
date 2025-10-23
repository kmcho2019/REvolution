module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// Define the output logic
// Since the output is 1 only in state D
assign out = state[3]; // state[3] corresponds to state D (4'b1000)

// Define the next state logic based on the current state and input
// For state A (4'b0001), next state is A if in=0, B if in=1
// For state B (4'b0010), next state is C if in=0, B if in=1
// For state C (4'b0100), next state is A if in=0, D if in=1
// For state D (4'b1000), next state is C if in=0, B if in=1
assign next_state = (
    // If current state is A
    (state == 4'b0001) ? (in ? 4'b0010 : 4'b0001) :
    // If current state is B
    (state == 4'b0010) ? (in ? 4'b0010 : 4'b0100) :
    // If current state is C
    (state == 4'b0100) ? (in ? 4'b1000 : 4'b0001) :
    // If current state is D
    (state == 4'b1000) ? (in ? 4'b0010 : 4'b0100) : 4'bxxxx
);

endmodule