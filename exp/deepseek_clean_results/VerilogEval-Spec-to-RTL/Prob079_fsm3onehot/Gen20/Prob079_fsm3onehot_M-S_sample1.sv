module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Simplified state transition logic
    assign next_state[0] = (~in) & (state[0] | state[2]);  // A next when in=0 from A or C
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // B next when in=1 from A,B,D
    assign next_state[2] = (~in) & (state[1] | state[3]);  // C next when in=0 from B or D
    assign next_state[3] = in & state[2];                  // D next when in=1 from C

    // Output is high only in state D
    assign out = state[3];

endmodule