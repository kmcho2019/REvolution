module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic with explicit state mapping:
    assign next_state[0] = ~in & (state[0] | state[2]);  // A: stays in A when in=0 or comes from C when in=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]);  // B: from A/B/D when in=1
    assign next_state[2] = ~in & (state[1] | state[3]);  // C: from B/D when in=0
    assign next_state[3] = in & state[2];                // D: from C when in=1

    // Output is high only in state D (one-hot MSB)
    assign out = state[3];

endmodule