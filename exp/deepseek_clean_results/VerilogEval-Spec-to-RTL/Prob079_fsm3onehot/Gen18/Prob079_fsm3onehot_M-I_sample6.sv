module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Shared subexpressions
    wire in_n = ~in;
    wire state2_n = ~state[2];

    // Optimized state transition logic
    assign next_state[0] = in_n & (state[0] | state[2]);  // A: from A(in=0) or C(in=0)
    assign next_state[1] = in & (state[0] | state[1] | state[3]) & state2_n; // B: optimized combined case
    assign next_state[2] = in_n & (state[1] | state[3]);  // C: from B(in=0) or D(in=0)
    assign next_state[3] = in & state[2];                // D: from C when in=1

    // Moore output: high only in state D
    assign out = state[3];

endmodule