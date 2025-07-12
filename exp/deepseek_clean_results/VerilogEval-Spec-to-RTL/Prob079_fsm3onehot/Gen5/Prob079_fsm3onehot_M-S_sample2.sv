module TopModule (
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

    // Simplified next state logic
    assign next_state[0] = (~in & (state[0] | state[2]));  // A or C -> A when in=0
    assign next_state[1] = in & (state[0] | state[1] | state[3]); // A/B/D -> B when in=1
    assign next_state[2] = (~in & (state[1] | state[3]));  // B or D -> C when in=0
    assign next_state[3] = in & state[2];                  // C -> D when in=1

    // Output is simply the D state bit
    assign out = state[3];

endmodule