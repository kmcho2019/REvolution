module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // State transition logic using priority-encoded parallel evaluation
    assign next_state[0] = (~in & state[0]) | (~in & state[2]);  // A transitions
    assign next_state[1] = (in & state[0]) | (in & state[1]) | (in & state[3]);  // B transitions
    assign next_state[2] = (~in & state[1]) | (~in & state[3]);  // C transitions
    assign next_state[3] = (in & state[2]);                      // D transitions

    // Output logic - only active in state D
    assign out = state[3];

endmodule