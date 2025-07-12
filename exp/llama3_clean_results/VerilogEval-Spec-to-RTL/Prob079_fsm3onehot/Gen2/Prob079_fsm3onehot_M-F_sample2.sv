module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic
    assign next_state[0] = (~in & state[0]) | (~in & state[2]); // A (in=0) or C (in=0)
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (~in & state[3]); // B (in=1) or B (in=1) or D (in=0)
    assign next_state[2] = (~in & state[1]) | (in & state[2]); // C (in=0) or C (in=1)
    assign next_state[3] = (in & state[2]); // D (in=1)

    // Output logic
    assign out = state[3]; // Output is 1 only when in state D

endmodule