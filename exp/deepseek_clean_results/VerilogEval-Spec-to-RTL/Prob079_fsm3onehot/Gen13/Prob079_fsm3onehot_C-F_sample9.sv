module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Optimized state transition logic for one-hot encoding
    assign next_state[0] = ~in & (state[0] | state[2]);  // A: from A(in=0) or C(in=0)
    assign next_state[1] = in & ~state[2];               // B: from A/B/D when in=1 (most optimized)
    assign next_state[2] = ~in & (state[1] | state[3]);  // C: from B(in=0) or D(in=0)
    assign next_state[3] = in & state[2];                // D: from C when in=1

    // Moore output: high only in state D (one-hot MSB)
    assign out = state[3];

endmodule